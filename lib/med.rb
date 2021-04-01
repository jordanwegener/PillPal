# This file contains all medication entry classes

class Medication
  attr_accessor :name, :inventory, :inventory_threshold

  def initialize(name)
    @name = name
  end
end

class Medication_weekly < Medication
  attr_accessor :days_taken, :hours_taken

  def initialize(name, days_taken, hours_taken)
    @name = name
    @days_taken = days_taken
    @hours_taken = hours_taken
  end
end

class Medication_daily < Medication
  attr_accessor :interval, :hours_taken

  def initialize(name, inverval, hours_taken)
    @name = name
    @interval = interval
    @hours_taken = hours_taken
  end
end
