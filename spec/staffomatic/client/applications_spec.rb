require 'helper'

describe Staffomatic::Client::Applications do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_applications", :vcr do
    it "returns all Staffomatic applications" do
      applications = @client.all_applications
      expect(applications).to be_kind_of Array
    end
    it "returns all location applications" do
      applications = @client.location_applications(64)
      expect(applications).to be_kind_of Array
    end
    it "returns all schedule applications" do
      applications = @client.schedule_applications(280913)
      expect(applications).to be_kind_of Array
    end
    it "returns all shift applications" do
      applications = @client.shift_applications(12676963)
      expect(applications).to be_kind_of Array
    end
  end # .all_applications

  describe ".application", :vcr do
    it "returns a application" do
      application = @client.application(24007576)
      expect(application.user_id).to eq(286948)
    end
  end # .application

  describe ".update_applications", :vcr do
    it "updates an application" do
      applications = @client.update_application(3173511, :attend_starts_at => "2014-08-26T07:20:00.000+02:00", :attend_ends_at => "2014-08-26T07:40:00.000+02:00")
      expect(applications.attend_starts_at).to eq(Time.parse("2014-08-26T07:20:00.000+02:00"))
      assert_requested :patch, staffomatic_url("/applications/#{3173511}")
    end

    # PUT Actions include:
    # * accept        (scheduler)        Accept! applied application
    # * revert        (scheduler)        Reverts! assigned application From accept to applied
    # * cancel        (staff, scheduler) Cancel! an assigned application
    # * revoke        (staff, scheduler) Revoke! `canceled` application
    # * remove|reject (scheduler)        Remove! or Reject! an applied application
    # * supersede     (staff, scheduler) Supersede! a `canceled` application.

    it "Accept! applied application" do
      applications = @client.accept_application(3173512)
      expect(applications.state).to eq('assigned')
      assert_requested :patch, staffomatic_url("/applications/#{3173512}")
    end

    it "Revert! an assigned application" do
      applications = @client.revert_application(3173512)
      expect(applications.state).to eq('applied')
      assert_requested :patch, staffomatic_url("/applications/#{3173512}")
    end

    it "Cancel! an assigned application" do
      applications = @client.cancel_application(3173512, "i honestly swear...")
      expect(applications.state).to eq('cancelled')
      assert_requested :patch, staffomatic_url("/applications/#{3173512}")
    end

    it "Revoke! a `canceled` application" do
      applications = @client.revoke_cancelled_application(3173511)
      expect(applications.state).to eq('assigned')
      assert_requested :patch, staffomatic_url("/applications/#{3173511}")
    end

    it "Remove! or Reject! an applied application" do
      applications = @client.reject_application(3173513)
      assert_requested :patch, staffomatic_url("/applications/#{3173513}")
    end

    it "Supersede! a `canceled` application" do
      applications = @client.supersede_application(3173514)
      expect(applications.user_id).to eq(493)
      assert_requested :patch, staffomatic_url("/applications/#{3173514}")
    end

  end # .update_applications

  describe ".create_application", :vcr do
    # POST Actions include:
    # * apply     (staff, scheduler)  Create an applied application
    # * assign    (~staff, scheduler) Create an assigned application

    it "creates an applied application" do
      application = @client.create_applied_application(2602188, 493)
      expect(application.user_id).to match(493)
      assert_requested :post, staffomatic_url("shifts/2602188/applications")
    end

    it "creates an assigned application" do
      application = @client.create_assigned_application(2602188, 493)
      expect(application.user_id).to match(493)
      assert_requested :post, staffomatic_url("shifts/2602188/applications")
    end

  end # .create_application

end
