# This file contains all medication entry classes

class Medication
  attr_accessor :name, :type, :inventory, :inventory_threshold

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
    @type = "weekly"
  end

  def display_medication
    puts "Medication name: \n#{@name}"
    puts "Days taken: "
    p @days_taken
    puts "Times taken: "
    p @times_taken
  end
end

class Medication_interval < Medication
  attr_accessor :interval, :times_taken

  def initialize(name, interval, times_taken)
    @name = name
    @interval = interval
    @times_taken = times_taken
    @type = "interval"
  end

  def display_medication
    puts "Medication name: \n#{@name}"
    puts "Dose interval: #{@interval} days"
    puts "Times taken: "
    p @times_taken
  end
end
