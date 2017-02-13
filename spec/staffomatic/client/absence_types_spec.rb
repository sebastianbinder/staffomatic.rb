require 'helper'

describe Staffomatic::Client::AbsenceTypes do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_absence_types", :vcr do

    it "returns all Staffomatic absence_types" do
      absence_types = @client.all_absence_types
      expect(absence_types).to be_kind_of Array
    end

    it "returns all Staffomatic absence_types for a location" do
      absence_types = @client.location_absence_types(24086)
      expect(absence_types).to be_kind_of Array
    end

  end # .all_absence_types

  describe ".absence_type", :vcr do
    it "returns a absence_type" do
      absence_type = @client.absence_type(14563)
      expect(absence_type.name).to eq('Holiday')
    end
  end # .absence_type

  describe ".update_absence_types", :vcr do
    it "updates a absence_type" do
      absence_types = @client.update_absence_type(14563, :visibility => 'schedulers')
      expect(absence_types.visibility).to eq('schedulers')
      assert_requested :patch, staffomatic_url("/absence_types/14563")
    end
  end # .update_absence_types

  describe ".create_absence_type", :vcr do
    it "creates a absence_type" do
      absence_type = @client.create_absence_type(24086, {:name => "Holiday", :color => "749ec1", :user_selectable => false})
      expect(absence_type.name).to match(/Holiday/)
      assert_requested :post, staffomatic_url("locations/24086/absence_types")
    end
  end # .create_absence_type

  describe ".delete_absence_type", :vcr do
    it "deletes an existing absence_type" do
      @client.delete_absence_type(14564)
      assert_requested :delete, staffomatic_url("/absence_types/#{14564}")
    end
  end # .delete_absence_type

end
