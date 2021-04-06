# This file contains all medication entry classes

require "date"

class Medication
  attr_accessor :name, :inventory, :inventory_threshold

  def initialize(name)
    @name = name
  end

  def inventory_setup(inventory, inventory_threshold)
    @inventory = inventory
    @inventory_threshold = inventory_threshold
  end
end

class Medication_weekly < Medication
  attr_accessor :days_taken, :times_taken

  def initialize(name, days_taken, times_taken)
    @name = name
    @days_taken = days_taken
    @times_taken = times_taken
  end

  def display_medication
    puts "Medication name: \n#{@name}"
    puts "Days taken: "
    @days_taken.each do |day|
      puts day
    end
    puts "Times taken: "
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}"
    end
  end

  def display_medication_short
    puts "Medication name: \n#{@name}"
    puts "Times taken: "
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}"
    end
  end

  def edit_medication(name, days_taken, times_taken)
    @name = name
    @days_taken = days_taken
    @times_taken = times_taken
  end
end

class Medication_interval < Medication
  attr_accessor :interval, :times_taken, :date_first_taken

  def initialize(name, interval, times_taken, date_first_taken)
    @name = name
    @interval = interval
    @times_taken = times_taken
    @date_first_taken = date_first_taken
  end

  def display_medication
    puts "Medication name: \n#{@name}"
    puts "Dose interval: \n#{@interval} days"
    puts "Times taken: "
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}"
    end
    puts "Date of first dose: \n#{@date_first_taken}"
  end

  def display_medication_short
    puts "Medication name: \n#{@name}"
    puts "Times taken: "
    @times_taken.each do |time|
      puts "#{time[:hour]}:#{time[:minute]}"
    end
  end

  def edit_medication(name, interval, times_taken, date_first_taken)
    @name = name
    @interval = interval
    @times_taken = times_taken
  end

  def check_needed(date)
    epoch = Date.new(1970, 1, 1)
    if ((((date - epoch).to_i) - ((@date_first_taken - epoch).to_i)) % @interval) == 0
      return true
    else
      return false
    end
  end
end
