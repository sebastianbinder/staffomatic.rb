require 'helper'

describe Staffomatic::Client::Locations do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_users", :vcr do
    it "returns all Staffomatic locations" do
      locations = @client.all_locations
      expect(locations).to be_kind_of Array
    end
  end # .all_locations

  describe ".location", :vcr do
    it "returns a location" do
      location = @client.location(64)
      expect(location.name).to eq('Research')
    end
  end # .location

  describe ".update_locations", :vcr do
    it "updates a locations profile" do
      locations = @client.update_location(64, :notes_visible => true)
      expect(locations.notes_visible).to eq(true)
      assert_requested :patch, staffomatic_url("/locations/#{64}")
    end
  end # .update_locations

  describe ".create_location", :vcr do
    it "creates an location" do
      location = @client.create_location('SuperBar')
      expect(location.name).to match(/SuperBar/)
      assert_requested :post, staffomatic_url("/locations")
    end
  end # .create_location

  describe ".delete_location" do
    xit "deletes an existing location" do
      @client.delete_location(8136)
      assert_requested :delete, staffomatic_url("/locations/#{8136}")
    end
  end # .delete_location

end
