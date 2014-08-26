require 'helper'

describe Staffomatic::Client::Schedules do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_schedules", :vcr do
    it "returns all Staffomatic schedules" do
      schedules = @client.all_schedules
      expect(schedules).to be_kind_of Array
    end
  end # .all_schedules

  describe ".schedule", :vcr do
    it "returns a schedule" do
      schedule = @client.schedule(71935)
      expect(schedule.bop).to eq('2014-07-21')
    end
  end # .schedule

  describe ".update_schedules", :vcr do
    it "updates a schedule" do
      schedules = @client.update_schedule(71935, :notes_visible => true)
      expect(schedules.notes_visible).to eq(true)
      assert_requested :patch, staffomatic_url("/schedules/#{71935}")
    end
    it "publish a schedule" do
      schedules = @client.publish_schedule(71935, :notes_visible => true)
      expect(schedules.state).to eq('published')
      assert_requested :patch, staffomatic_url("/schedules/#{71935}")
    end
    it "republish a schedule" do
      schedules = @client.republish_schedule(71935, :notes_visible => true)
      expect(schedules.state).to eq('published')
      assert_requested :patch, staffomatic_url("/schedules/#{71935}")
    end
    it "delete_shifts from a schedule" do
      schedules = @client.bulk_delete_schedule_shifts(71935, [1,2,3])
      assert_requested :patch, staffomatic_url("/schedules/#{71935}")
    end
    it "import schedule from another schedule" do
      schedules = @client.import_shifts_from_schedule(71935, 67551, true, [1,2,3])
      assert_requested :patch, staffomatic_url("/schedules/#{71935}")
    end
    it "bulk accept applications in schedule" do
      schedules = @client.accept_applications_in_schedule(71935, false, [22612], [779])
      assert_requested :patch, staffomatic_url("/schedules/#{71935}")
    end
  end # .update_schedules

  describe ".create_schedule", :vcr do
    it "creates a schedule" do
      schedule = @client.create_schedule(64, {:bop => "2014-08-25", :deadline => "2014-08-21T00:00:00.000+02:00"})
      expect(schedule.bop).to match(/2014-08-25/)
      assert_requested :post, staffomatic_url("locations/64/schedules")
    end
  end # .create_schedule

  describe ".delete_schedule" do
    xit "deletes an existing schedule" do
      @client.delete_schedule(71934)
      assert_requested :delete, staffomatic_url("/schedules/#{71934}")
    end
  end # .delete_schedule

end
