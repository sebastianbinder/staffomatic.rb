require 'helper'

describe Staffomatic::Client::BreakTimers do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_break_timers", :vcr do

    it "returns all Staffomatic break_timers" do
      break_timers = @client.all_break_timers
      expect(break_timers).to be_kind_of Array
    end

    it "returns all Staffomatic break_timers for a work_timer" do
      break_timers = @client.work_timer_breaks(91)
      expect(break_timers).to be_kind_of Array
    end

  end # .all_break_timers

  describe ".break_timer", :vcr do
    it "returns a break_timer" do
      break_timer = @client.break_timer(40)
      expect(break_timer.id).to eq(40)
    end
  end # .break_timer

  describe ".update_break_timers", :vcr do
    it "updates a break_timer" do
      break_timers = @client.update_break_timer(40, {starts_at: "2017-02-13T09:01:02+01:00"})
      expect(break_timers.starts_at).to eq(Time.parse('2017-02-13 09:01:02 +0100'))
      assert_requested :patch, staffomatic_url("/break_timers/40")
    end
  end # .update_break_timers

  describe ".create_break_timer", :vcr do
    it "creates a break_timer" do
      break_timer = @client.create_break_timer(91, {starts_at: "2017-02-13T09:45:01+01:00", :do => "start"})
      expect(break_timer.user_id).to eq(286948)
      assert_requested :post, staffomatic_url("work_timers/#{91}/break_timers")
    end
  end # .create_break_timer

  describe ".delete_break_timer", :vcr do
    it "deletes an existing break_timer" do
      @client.delete_break_timer(41)
      assert_requested :delete, staffomatic_url("/break_timers/41")
    end
  end # .delete_break_timer

end
