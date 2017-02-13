require 'helper'

describe Staffomatic::Client::Account do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".account", :vcr do
    it "returns account" do
      account = @client.get_account
      expect(account.name).to eq('staffomatic-rb')
    end
  end # .account

  describe ".update_account", :vcr do
    it "updates a account" do
      account = @client.update_account({:reports_editable_for_staff => false})
      expect(account.reports_editable_for_staff).to eq false
      assert_requested :patch, staffomatic_url("/account")
    end

  end # .update_account

end
