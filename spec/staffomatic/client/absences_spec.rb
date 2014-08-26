require 'helper'

describe Staffomatic::Client::Absences do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_absences", :vcr do
    it "returns all Staffomatic absences" do
      absences = @client.all_absences
      expect(absences).to be_kind_of Array
    end

    it "returns all location absences" do
      absences = @client.location_absences(64)
      expect(absences).to be_kind_of Array
    end

    it "returns filtered absences" do
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

    it "Approve! new absence" do
      absences = @client.approve_absence(43126)
      expect(absences.state).to eq('approved')
      assert_requested :patch, staffomatic_url("/absences/#{43126}")
    end

    it "Decline! a new absence" do
      absences = @client.decline_absence(36957)
      expect(absences.state).to eq('declined')
      assert_requested :patch, staffomatic_url("/absences/#{36957}")
    end

  end # .update_absences

  describe ".create_absence", :vcr do

    fit "creates an absence" do
      absence = @client.create_absence({
        starts_at: "2014-09-20T07:20:00.000+02:00",
        ends_at: "2014-09-26T07:40:00.000+02:00",
        applicant_id: 493,
        absence_type_id: 1,
        paid: true,
        vacation: true,
        include_weekends: true,
        all_day: true,
        adjusted_duration: (4*24*60*60),
        justification: "Grandma died.",
        commentable: false,
        attachable: false
      })
      expect(absence.applicant_id).to match(493)
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
