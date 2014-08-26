require 'helper'

describe Staffomatic::Client::Users do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_users", :vcr do
    it "returns all Staffomatic users" do
      users = @client.all_users
      expect(users).to be_kind_of Array
    end
  end # .all_users

  describe ".user", :vcr do
    it "returns a user" do
      user = @client.user(493)
      expect(user.email).to eq('admin@demo.de')
    end
    it "returns the authenticated user" do
      user = @client.user
      expect(user.email).to eq(test_staffomatic_email)
    end
  end # .user

  describe ".validate_credentials", :vcr do
    it "validates email and  password" do
      expect(Staffomatic.validate_credentials(
        :email => test_staffomatic_email,
        :password => test_staffomatic_password,
        :account => test_staffomatic_account,
        :scheme => test_staffomatic_scheme
      )).to be true
    end
  end # .validate_credentials

  describe ".update_user", :vcr do
    it "updates a user profile" do
      user = @client.update_user(:city => "San Francisco", :locale => 'de')
      expect(user.email).to eq(test_staffomatic_email)
      assert_requested :patch, staffomatic_url("/user")
    end
  end # .update_user

  describe ".exchange_code_for_token" do
    context "with application authenticated client" do
      xit "returns the access_token" do
        pending("generating access token with web flow is not yet supported")
        client = Staffomatic::Client.new({client_id: '123', client_secret: '345'})
        request = stub_post("#{test_staffomatic_api_endpoint}/oauth/access_token?client_id=123&client_secret=345").
          with(:body => {:code=>"code", :client_id=>"123", :client_secret=>"345"}.to_json).
          to_return(json_response("web_flow_token.json"))
        response = client.exchange_code_for_token("code")
        expect(response.access_token).to eq "this_be_ye_token/use_it_wisely"
        assert_requested request
      end
    end # with application authenticated client

    context 'with credentials passed as parameters by unauthed client' do
      xit 'returns the access_token' do
        pending("generating access token with web flow is not yet supported")
        client = Staffomatic::Client.new
        post = stub_request(:post, "#{test_staffomatic_api_endpoint}/oauth/access_token").
          with(:body => {:code=>"code", :client_id=>"id", :client_secret=>"secret"}.to_json).
          to_return(json_response("web_flow_token.json"))
        response = client.exchange_code_for_token('code', 'id', 'secret')
        expect(response.access_token).to eq 'this_be_ye_token/use_it_wisely'
        assert_requested post
      end
    end # with credentials passed as parameters
  end # .exchange_code_for_token
end
