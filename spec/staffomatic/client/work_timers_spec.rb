require 'helper'

describe Staffomatic::Client::WorkTimers do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_work_timers", :vcr do

    it "returns all Staffomatic work_timers" do
      work_timers = @client.all_work_timers
      expect(work_timers).to be_kind_of Array
    end

    it "returns all Staffomatic work_timers for a location" do
      work_timers = @client.location_work_timers(24086)
      expect(work_timers).to be_kind_of Array
    end

  end # .all_work_timers

  describe ".work_timer", :vcr do
    it "returns a work_timer" do
      work_timer = @client.work_timer(91)
      expect(work_timer.id).to eq(91)
    end
  end # .work_timer

  describe ".update_work_timers", :vcr do
    it "updates a work_timer" do
      work_timers = @client.update_work_timer(91, {do: "verify"})
      expect(work_timers.state).to eq('verified')
      assert_requested :patch, staffomatic_url("/work_timers/91")
    end
  end # .update_work_timers

  describe ".create_work_timer", :vcr do
    it "creates a work_timer" do
      work_timer = @client.create_work_timer({user_id: 286948, starts_at: "2014-12-08 03:30:00.000+02:00", :do => "start"})
      expect(work_timer.user_id).to eq(286948)
      assert_requested :post, staffomatic_url("work_timers")
    end
  end # .create_work_timer

  describe ".delete_work_timer", :vcr do
    it "deletes an existing work_timer" do
      @client.delete_work_timer(92)
      assert_requested :delete, staffomatic_url("/work_timers/92")
    end
  end # .delete_work_timer

end
