require_relative "../lib/med.rb"
require "date"

ARGV.clear

RSpec.describe MedicationInterval do
  subject(:medicationinterval) do
    described_class.new("Test Interval Medication", "40mg", 2, 2, [{ :hour => "09", :minute => "00", :second_of_day => 32400 }, { :hour => "21", :minute => "00", :second_of_day => 75600 }], (Date.new(2021, 4, 9)))
  end

  describe "#take_within_hours" do
    it "should" do
      expect(medicationinterval.check_needed((2021,4,11).to_date))
    end
  end
end
