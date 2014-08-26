require 'helper'

describe Staffomatic::Client::Shifts do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_shifts", :vcr do
    it "returns all Staffomatic shifts" do
      shifts = @client.all_shifts
      expect(shifts).to be_kind_of Array
    end
  end # .all_shifts

  describe ".shift", :vcr do
    it "returns a shift" do
      shift = @client.shift(2602188)
      expect(shift.starts_at).to eq(Time.parse("2014-08-26 03:30:00.000000000 +0200"))
    end
  end # .shift

  describe ".update_shifts", :vcr do
    it "updates a shift" do
      shifts = @client.update_shift(2602188, :note => "Some awesome note")
      expect(shifts.note).to eq("Some awesome note")
      assert_requested :patch, staffomatic_url("/shifts/#{2602188}")
    end
  end # .update_shifts

  describe ".create_shift", :vcr do
    it "creates a shift" do
      shift = @client.create_shift(71935, 22612, {:desired_coverage => 2, :starts_at => "2014-08-26 03:30:00.000+02:00", :ends_at => "2014-08-26 06:30:00.000+02:00"})
      expect(shift.starts_at).to eq Time.parse("2014-08-26 03:30:00.000+02:00")
      assert_requested :post, staffomatic_url("schedules/71935/shifts")
    end
  end # .create_shift

  describe ".delete_shift" do
    xit "deletes an existing shift" do
      @client.delete_shift(2602192)
      assert_requested :delete, staffomatic_url("/shifts/#{2602192}")
    end
  end # .delete_shift

end
