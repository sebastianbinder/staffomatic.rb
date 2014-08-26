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
      absence_types = @client.location_absence_types(64)
      expect(absence_types).to be_kind_of Array
    end

  end # .all_absence_types

  describe ".absence_type", :vcr do
    it "returns a absence_type" do
      absence_type = @client.absence_type(1)
      expect(absence_type.name).to eq('Urlaub')
    end
  end # .absence_type

  describe ".update_absence_types", :vcr do
    it "updates a absence_type" do
      absence_types = @client.update_absence_type(1, :visibility => 'schedulers')
      expect(absence_types.visibility).to eq('schedulers')
      assert_requested :patch, staffomatic_url("/absence_types/1")
    end
  end # .update_absence_types

  describe ".create_absence_type", :vcr do
    it "creates a absence_type" do
      absence_type = @client.create_absence_type(64, {:name => "Holiday", :color => "749ec1"})
      expect(absence_type.name).to match(/Holiday/)
      assert_requested :post, staffomatic_url("locations/64/absence_types")
    end
  end # .create_absence_type

  describe ".delete_absence_type" do
    xit "deletes an existing absence_type" do
      @client.delete_absence_type(5730)
      assert_requested :delete, staffomatic_url("/absence_types/#{5730}")
    end
  end # .delete_absence_type

end
