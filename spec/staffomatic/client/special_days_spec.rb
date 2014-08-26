require 'helper'

describe Staffomatic::Client::SpecialDays do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_special_days", :vcr do

    it "returns all Staffomatic special_days" do
      special_days = @client.all_special_days
      expect(special_days).to be_kind_of Array
    end

    it "returns all Staffomatic special_days for a location" do
      special_days = @client.location_special_days(64)
      expect(special_days).to be_kind_of Array
    end

  end # .all_special_days

  describe ".special_day", :vcr do
    it "returns a special_day" do
      special_day = @client.special_day(1)
      expect(special_day.name).to eq('Neujahrstag')
    end
  end # .special_day

  describe ".update_special_days", :vcr do
    it "updates a special_day" do
      special_days = @client.update_special_day(1, :show_in_schedule => false)
      expect(special_days.show_in_schedule).to eq(false)
      assert_requested :patch, staffomatic_url("/special_days/1")
    end
  end # .update_special_days

  describe ".create_special_day", :vcr do
    it "creates a special_day" do
      special_day = @client.create_special_day(64, { :starts_at => "2014-12-08 03:30:00.000+02:00",
                                                     :ends_at => "2014-12-20 03:30:00.000+02:00",
                                                     :name => "BILLABONG PIPE MASTERS",
                                                     :description => "Men's World Championship Tour #11",
                                                     :color => "749ec1",
                                                     :public_holiday => false,
                                                     :show_in_schedule => true,
                                                     :allow_absences => false,
                                                     :all_day => true } )
      expect(special_day.name).to match(/BILLABONG PIPE MASTERS/)
      assert_requested :post, staffomatic_url("locations/64/special_days")
    end
  end # .create_special_day

  describe ".delete_special_day" do
    xit "deletes an existing special_day" do
      @client.delete_special_day(19116)
      assert_requested :delete, staffomatic_url("/special_days/19116")
    end
  end # .delete_special_day

end
