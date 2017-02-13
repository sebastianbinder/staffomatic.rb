require 'helper'

describe Staffomatic::Client::WorkReports do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_work_reports", :vcr do

    it "returns all Staffomatic work_reports" do
      work_reports = @client.all_work_reports
      expect(work_reports).to be_kind_of Array
    end

    it "returns all Staffomatic work_reports for a location" do
      work_reports = @client.location_work_reports(24086)
      expect(work_reports).to be_kind_of Array
    end

  end # .all_work_reports

  describe ".work_report", :vcr do
    it "returns a work_report" do
      work_report = @client.work_report(37)
      expect(work_report.id).to eq(37)
    end
  end # .work_report

end
