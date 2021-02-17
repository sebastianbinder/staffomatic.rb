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
    it "returns all location users" do
      users = @client.location_users(64)
      expect(users).to be_kind_of Array
    end
  end # .all_users

  describe ".user", :vcr do
    it "returns a user" do
      user = @client.user(493)
      expect(user.email).to eq('admin@example.com')
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
      user = @client.update_user(493, {:city => "San Francisco", :locale => 'de'})
      expect(user.city).to match(/San Francisco/)
      assert_requested :patch, staffomatic_url("/users/493")
    end

    it "lock a user" do
      user = @client.lock_user(66912)
      expect(user.locked_at).not_to be_nil
      assert_requested :patch, staffomatic_url("/users/66912")
    end

    it "unlock a user" do
      user = @client.unlock_user(66912)
      expect(user.locked_at).to be_nil
      assert_requested :patch, staffomatic_url("/users/66912")
    end

  end # .update_user

  describe ".create_user", :vcr do

    it "invite a user" do
      user = @client.invite_user({ email: 'hello+a1@example.com',
                                   role: 'staff',
                                   locale: 'en' })
      expect(user.email).to match(/hello\+a1@example.com/)
      assert_requested :post, staffomatic_url("users")
    end

    it "creates a user" do
      user = @client.create_user({ :role => "staff",
                                   :first_name => "Franzl",
                                   :last_name => "Hostädtler" })
      expect(user.full_name).to match(/Franzl Hostädtler/)
      assert_requested :post, staffomatic_url("users")
    end

  end # .create_user

  describe ".delete_user" do
    xit "deletes an existing user" do
      @client.delete_user(66912)
      assert_requested :delete, staffomatic_url("/users/66912")
    end
  end # .delete_user

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
