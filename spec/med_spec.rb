require_relative "../lib/med.rb"
require "date"

RSpec.describe MedicationInterval do
  subject(:medicationinterval) do
    described_class.new("Test Interval Medication", "40mg", 2, 2, [{ :hour => "09", :minute => "00", :second_of_day => 32400 }, { :hour => "21", :minute => "00", :second_of_day => 75600 }], (Date.new(2021, 4, 9)))
  end

  describe "#check_needed" do
    it "should return true for dates that are multiples of (interval) days from date_first_taken" do
      expect(medicationinterval.check_needed(Date.new(2021, 4, 11))).to eq(true)
    end
  end

  describe "#check_needed" do
    it "should return false for dates that are not multiples of (interval) days from date_first_taken" do
      expect(medicationinterval.check_needed(Date.new(2021, 4, 12))).to eq(false)
    end
  end

  describe "#take_within_hours" do
    it "should return something if medication needs to be taken within 24 hours" do
      expect(described_class.new("Test Interval Medication", "40mg", 2, 1, [{ :hour => "09", :minute => "00", :second_of_day => 32400 }, { :hour => "21", :minute => "00", :second_of_day => 75600 }], (Date.today)).take_within_hours(24)).not_to eq([])
    end
  end

  describe "#take_within_hours" do
    it "should return nothing if medication does not need to be taken within 24 hours" do
      expect(described_class.new("Test Interval Medication", "40mg", 2, 5, [{ :hour => "00", :minute => "00", :second_of_day => 0 }], (Date.today + -1)).take_within_hours(24)).to eq([])
    end
  end
end
RSpec.describe MedicationWeekly do
  subject(:medicationweekly) do
    described_class.new("Test Weekly Medication", "40mg", 2, ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], [{ :hour => "09", :minute => "00", :second_of_day => 32400 }, { :hour => "21", :minute => "00", :second_of_day => 75600 }])
  end

  describe "#take_within_hours" do
    it "should return something if medication needs to be taken within 24 hours" do
      expect(medicationweekly.take_within_hours(24)).not_to eq([])
    end
  end

  describe "#take_within_hours" do
    it "should return nothing if medication does not need to be taken within 24 hours" do
      expect((described_class.new("Test Weekly Medication", "40mg", 2, [], [{ :hour => "09", :minute => "00", :second_of_day => 32400 }, { :hour => "21", :minute => "00", :second_of_day => 75600 }])).take_within_hours(24)).to eq([])
    end
  end
end
