# This file contains all medication entry classes

require "date"
require "tod"
require "tod/core_extensions"

class Medication
  attr_accessor :name, :inventory, :inventory_threshold, :dose, :number_taken

  def initialize(name)
    @name = name
  end

  def inventory_setup(inventory, inventory_threshold)
    @inventory = inventory
    @inventory_threshold = inventory_threshold
  end
end

class MedicationWeekly < Medication
  attr_accessor :days_taken, :times_taken

  def initialize(name, dose, number_taken, days_taken, times_taken)
    @name = name
    @dose = dose
    @number_taken = number_taken
    @days_taken = days_taken
    @times_taken = times_taken
  end

  def display_medication
    puts "Medication name: \n#{@name}\n\n"
    puts "Dose: \n#{@dose}\n\n"
    puts "Number taken: #{@number_taken}\n\n"
    puts "Days taken: "
    @days_taken.each do |day|
      puts day
    end
    puts "\n"
    puts "Times taken: "
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}"
    end
  end

  def display_medication_short
    puts "\nMedication name: \n#{@name}\n\n"
    puts "Number taken: #{@number_taken}\n\n"
    puts "Times taken: "
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}\n"
    end
  end

  def edit_medication(name, days_taken, times_taken)
    @name = name
    @days_taken = days_taken
    @times_taken = times_taken
  end

  def take_within_hours(hours)
    start = Time.now
    final = start + (hours * 3600)
    pills_to_take = @times_taken.filter do |time_stamp|
      if time_stamp[:hour].to_i > start.hour
        time_stamp = Time.new(start.year, start.month, start.day, time_stamp[:hour].to_i, time_stamp[:minute].to_i)
      else
        time_stamp = Time.new(start.year, start.month, start.day + 1, time_stamp[:hour].to_i, time_stamp[:minute].to_i)
      end
      @days_taken.include?(time_stamp.strftime("%A")) && time_stamp >= start && time_stamp <= final
    end
    pills_to_take.each do |time|
      puts "\nTake #{@number_taken} of #{@name} (#{dose}) at #{time[:hour]}:#{time[:minute]}\n"
    end
  end
end

class MedicationInterval < Medication
  attr_accessor :interval, :times_taken, :date_first_taken

  def initialize(name, dose, number_taken, interval, times_taken, date_first_taken)
    @name = name
    @dose = dose
    @number_taken = number_taken
    @interval = interval
    @times_taken = times_taken
    @date_first_taken = date_first_taken
  end

  def display_medication
    puts "Medication name: \n#{@name}\n\n"
    puts "Dose: \n#{@dose}\n\n"
    puts "Number taken: #{@number_taken}\n\n"
    puts "Dose interval: \n#{@interval} days\n\n"
    puts "Times taken: "
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}"
    end
    puts "\n"
    puts "Date of first dose: \n#{@date_first_taken}"
  end

  def display_medication_short
    puts "\nMedication name: \n#{@name}\n\n"
    puts "Number taken: #{@number_taken}\n\n"
    puts "Times taken: "
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}\n"
    end
  end

  def edit_medication(name, interval, times_taken, date_first_taken)
    @name = name
    @interval = interval
    @times_taken = times_taken
  end

  def check_needed(date)
    epoch = Date.new(1970, 1, 1)
    ((((date - epoch).to_i) - ((@date_first_taken - epoch).to_i)) % @interval) == 0
  end

  def take_within_hours(hours)
    start = Time.now
    day = 24 * 3600
    final = start + (hours * 3600)
    pills_to_take = @times_taken.filter do |time_stamp|
      if time_stamp[:hour].to_i > start.hour
        time_stamp = Time.new(start.year, start.month, start.day, time_stamp[:hour].to_i, time_stamp[:minute].to_i)
      else
        time_stamp = Time.new(start.year, start.month, start.day + 1, time_stamp[:hour].to_i, time_stamp[:minute].to_i)
      end
      self.check_needed(time_stamp.to_date) && time_stamp >= start && time_stamp <= final
    end
    pills_to_take.each do |time|
      puts "\nTake #{@number_taken} of #{@name} (#{dose}) at #{time[:hour]}:#{time[:minute]}\n"
    end
  end
end
