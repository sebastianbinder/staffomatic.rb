require 'helper'

describe Staffomatic::Client::Departments do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_departments", :vcr do

    it "returns all Staffomatic departments" do
      departments = @client.all_departments
      expect(departments).to be_kind_of Array
    end

    it "returns all Staffomatic departments for a location" do
      departments = @client.location_departments(64)
      expect(departments).to be_kind_of Array
    end

  end # .all_departments

  describe ".department", :vcr do
    it "returns a department" do
      department = @client.department(193)
      expect(department.name).to eq('Outdoors')
    end
  end # .department

  describe ".update_departments", :vcr do
    it "updates a department" do
      departments = @client.update_department(193, :user_ids => [493])
      expect(departments.user_ids).to eq([493])
      assert_requested :patch, staffomatic_url("/departments/193")
    end
  end # .update_departments

  describe ".create_department", :vcr do
    fit "creates a department" do
      department = @client.create_department(64, { :name => "Door",
                                                   :primary_color => "7ed0cf",
                                                   :user_ids => [493] })

      expect(department.name).to match(/Door/)
      assert_requested :post, staffomatic_url("locations/64/departments")
    end
  end # .create_department

  describe ".delete_department" do
    xit "deletes an existing department" do
      @client.delete_department(19116)
      assert_requested :delete, staffomatic_url("/departments/19116")
    end
  end # .delete_department

end
