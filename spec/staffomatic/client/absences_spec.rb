require 'helper'

describe Staffomatic::Client::Absences do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_absences", :vcr do
    fit "returns all Staffomatic absences" do
      absences = @client.all_absences
      expect(absences).to be_kind_of Array
    end

    fit "returns all location absences" do
      absences = @client.location_absences(24086)
      expect(absences).to be_kind_of Array
    end

    fit "returns filtered absences" do
      absences = @client.all_absences(:state => 'approved')
      expect(absences).to be_kind_of Array
    end
  end # .all_absences

  describe ".absence", :vcr do
    it "returns a absence" do
      absence = @client.absence(45034)
      expect(absence.handler_id).to eq(493)
    end
  end # .absence

  describe ".update_absences", :vcr do
    it "updates an absence" do
      # :all_day => true forces the absence to begin/end from beginning/end of day
      absences = @client.update_absence(45034, :all_day => true, :starts_at => "2014-08-20T07:20:00.000+02:00", :ends_at => "2014-08-26T07:40:00.000+02:00")
      expect(absences.starts_at).to eq(Time.parse("2014-08-20T00:00:00.000+02:00"))
      expect(absences.ends_at).to eq(Time.parse("2014-08-26T23:59:59.000+02:00"))
      assert_requested :patch, staffomatic_url("/absences/#{45034}")
    end

    # PUT Actions include:
    # * accept        (scheduler)        Accept! applied absence
    # * revert        (scheduler)        Reverts! assigned absence From accept to applied

    fit "Approve! new absence", :vcr do
      absences = @client.approve_absence(565580)
      expect(absences.state).to eq('approved')
      assert_requested :patch, staffomatic_url("/absences/#{565580}")
    end

    fit "Decline! a new absence" do
      absences = @client.decline_absence(565586)
      expect(absences.state).to eq('declined')
      assert_requested :patch, staffomatic_url("/absences/#{565586}")
    end

  end # .update_absences

  describe ".create_absence", :vcr do

    fit "creates an absence" do
      absence = @client.create_absence({
        starts_at: "2014-09-20T07:20:00.000+02:00",
        ends_at: "2014-09-26T07:40:00.000+02:00",
        applicant_id: 286946,
        absence_type_id: 14563,
        paid: true,
        vacation: true,
        include_weekends: true,
        all_day: true,
        adjusted_duration: (4*24*60*60),
        justification: "Grandma died.",
        commentable: false,
        attachable: false
      })
      expect(absence.applicant_id).to match(286946)
      assert_requested :post, staffomatic_url("absences")
    end

  end # .create_absence

  describe ".delete_absence" do
    it "deletes an existing absence" do
      @client.delete_absence(72174)
      assert_requested :delete, staffomatic_url("/absences/72174")
    end
  end # .delete_absence

end
