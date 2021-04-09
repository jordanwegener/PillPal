# This file contains all medication entry classes

require "date"
require "tod"
require "tod/core_extensions"
require "colorize"

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
    puts "Medication name:".colorize(:cyan)
    puts "#{@name}".colorize(:light_cyan)
    puts "Dose: ".colorize(:light_magenta)
    puts "#{@dose}"
    puts "Number taken: ".colorize(:light_magenta)
    puts "#{@number_taken}"
    puts "Days taken: ".colorize(:light_magenta)
    @days_taken.each do |day|
      puts day
    end
    puts "Times taken: ".colorize(:light_magenta)
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}"
    end
  end

  def display_medication_short
    puts "\nMedication name: ".colorize(:cyan)
    puts "#{@name}".colorize(:light_cyan)
    puts "Number taken: ".colorize(:light_magenta)
    puts "#{@number_taken}"
    puts "Times taken: ".colorize(:light_magenta)
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}\n"
    end
    puts "\n"
  end

  def edit_medication(name, dose, number_taken, days_taken, times_taken)
    @name = name
    @dose = dose
    @number_taken = number_taken
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
      puts "\nTake " + "#{@number_taken}".colorize(:cyan) + " of " + "#{@name} (#{dose})".colorize(:magenta) + " at " + "#{time[:hour]}:#{time[:minute]}".colorize(:yellow) + "\n"
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
    puts "Medication name: ".colorize(:cyan)
    puts "#{@name}".colorize(:light_cyan)
    puts "Dose: ".colorize(:light_magenta)
    puts "#{@dose}"
    puts "Number taken: ".colorize(:light_magenta)
    puts "#{@number_taken}"
    puts "Dose interval: ".colorize(:light_magenta)
    puts "#{@interval} days"
    puts "Times taken: ".colorize(:light_magenta)
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}"
    end
    puts "Date of first dose: ".colorize(:light_magenta)
    puts "#{@date_first_taken}"
  end

  def display_medication_short
    puts "\nMedication name: ".colorize(:cyan)
    puts "#{@name}".colorize(:light_cyan)
    puts "Number taken: ".colorize(:light_magenta)
    puts "#{@number_taken}"
    puts "Times taken: ".colorize(:light_magenta)
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}\n"
    end
    puts "\n"
  end

  def edit_medication(name, dose, number_taken, interval, times_taken, date_first_taken)
    @name = name
    @dose = dose
    @number_taken = number_taken
    @interval = interval
    @times_taken = times_taken
    @date_first_taken = date_first_taken
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
      puts "\nTake " + "#{@number_taken}".colorize(:cyan) + " of " + "#{@name} (#{dose})".colorize(:magenta) + " at " + "#{time[:hour]}:#{time[:minute]}".colorize(:yellow) + "\n"
    end
  end
end
