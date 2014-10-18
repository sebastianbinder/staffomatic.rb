require 'helper'
require 'json'

describe Staffomatic::Client do

  before do
    Staffomatic.reset!
  end

  after do
    Staffomatic.reset!
  end

  describe "module configuration" do

    before do
      Staffomatic.reset!
      Staffomatic.configure do |config|
        Staffomatic::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Staffomatic.reset!
    end

    it "inherits the module configuration" do
      client = Staffomatic::Client.new
      Staffomatic::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
          :per_page     => 40,
          :email        => "admin@easypep.de",
          :password     => "welcome",
          :account      => "demo",
          :scheme       => 'https',
          :api_endpoint => 'https://api.staffomaticapp.com/v3/demo'
        }
      end

      it "overrides module configuration" do
        client = Staffomatic::Client.new(@opts)

        expect(client.per_page).to eq(40)

        expect(client.email).to eq("admin@demo.de")
        expect(client.instance_variable_get(:"@password")).to eq("welcome")
        expect(client.scheme).to eq('https')
        expect(client.account).to eq('demo')
        expect(client.api_endpoint).to eq('https://api.staffomaticapp.com/v3/demo/')

        expect(client.auto_paginate).to eq(Staffomatic.auto_paginate)
        expect(client.client_id).to eq(Staffomatic.client_id)
      end

      it "can set configuration after initialization" do
        client = Staffomatic::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.per_page).to eq(40)
        expect(client.email).to eq("admin@demo.de")
        expect(client.instance_variable_get(:"@password")).to eq("welcome")
        expect(client.auto_paginate).to eq(Staffomatic.auto_paginate)
        expect(client.client_id).to eq(Staffomatic.client_id)
      end

      it "set development client configs" do
        Staffomatic.reset!
        client = Staffomatic::Client.new(
          scheme: 'http',
          access_token: 'sometoken',
          account: 'demo',
          api_endpoint: 'http://staffomatic-api.dev/v3/demo'
        )
        expect(client.scheme).to eq('http')
        expect(client.access_token).to eq('sometoken')
        expect(client.instance_variable_get(:"@account")).to eq('demo')
        expect(client.api_endpoint).to eq('http://staffomatic-api.dev/v3/demo')
      end

      it "masks passwords on inspect" do
        client = Staffomatic::Client.new(@opts)
        inspected = client.inspect
        expect(inspected).not_to include("welcome")
      end

      it "masks tokens on inspect" do
        client = Staffomatic::Client.new(:access_token => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).not_to include("87614b09dd141c22800f96f11737ade5226d7ba8")
      end

      it "masks client secrets on inspect" do
        client = Staffomatic::Client.new(:client_secret => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).not_to include("87614b09dd141c22800f96f11737ade5226d7ba8")
      end

    end
  end

  describe "authentication" do
    before do
      Staffomatic.reset!
      @client = Staffomatic.client
    end

    describe "with module level config" do
      before do
        Staffomatic.reset!
      end
      it "sets basic auth creds with .configure" do
        Staffomatic.configure do |config|
          config.email = 'admin@demo.de'
          config.password = 'welcome'
          config.account = 'demo'
        end
        expect(Staffomatic.client).to be_basic_authenticated
      end
      it "sets basic auth creds with module methods" do
        Staffomatic.email = 'admin@demo.de'
        Staffomatic.password = 'welcome'
        expect(Staffomatic.client).to be_basic_authenticated
      end
      it "sets oauth token with .configure" do
        Staffomatic.configure do |config|
          config.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(Staffomatic.client).not_to be_basic_authenticated
        expect(Staffomatic.client).to be_token_authenticated
      end
      it "sets oauth token with module methods" do
        Staffomatic.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(Staffomatic.client).not_to be_basic_authenticated
        expect(Staffomatic.client).to be_token_authenticated
      end
      it "sets oauth application creds with .configure" do
        Staffomatic.configure do |config|
          config.client_id     = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(Staffomatic.client).not_to be_basic_authenticated
        expect(Staffomatic.client).not_to be_token_authenticated
        expect(Staffomatic.client).to be_application_authenticated
      end
      it "sets oauth token with module methods" do
        Staffomatic.client_id     = '97b4937b385eb63d1f46'
        Staffomatic.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(Staffomatic.client).not_to be_basic_authenticated
        expect(Staffomatic.client).not_to be_token_authenticated
        expect(Staffomatic.client).to be_application_authenticated
      end
    end

    describe "with class level config" do
      it "sets basic auth creds with .configure" do
        @client.configure do |config|
          config.email = 'admin@demo.de'
          config.password = 'welcome'
        end
        expect(@client).to be_basic_authenticated
      end
      it "sets basic auth creds with instance methods" do
        @client.email = 'admin@demo.de'
        @client.password = 'welcome'
        expect(@client).to be_basic_authenticated
      end
      it "sets oauth token with .configure" do
        @client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).not_to be_basic_authenticated
        expect(@client).to be_token_authenticated
      end
      it "sets oauth token with instance methods" do
        @client.access_token = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).not_to be_basic_authenticated
        expect(@client).to be_token_authenticated
      end
      it "sets oauth application creds with .configure" do
        @client.configure do |config|
          config.client_id     = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(@client).not_to be_basic_authenticated
        expect(@client).not_to be_token_authenticated
        expect(@client).to be_application_authenticated
      end
      it "sets oauth token with module methods" do
        @client.client_id     = '97b4937b385eb63d1f46'
        @client.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).not_to be_basic_authenticated
        expect(@client).not_to be_token_authenticated
        expect(@client).to be_application_authenticated
      end
    end

    describe "when basic authenticated"  do
      it "makes authenticated calls" do
        Staffomatic.configure do |config|
          config.email = 'admin@demo.de'
          config.password = 'welcome'
          config.account = 'demo'
        end
        root_request = stub_get("https://admin%40demo.de:welcome@api.staffomatic-api.dev/v3/demo")
        Staffomatic.client.get("/api")
        assert_requested root_request
      end
    end

    describe "when token authenticated", :vcr do
      it "makes authenticated calls" do
        client = oauth_client

        root_request = stub_get("https://api.staffomaticapp.com/demo/api").
          with(:headers => {:authorization => "Bearer #{test_staffomatic_token}"})
        client.get("/api")
        assert_requested root_request
      end
      it "fetches and memoizes login" do
        client = oauth_client
        expect(client.email).to eq(test_staffomatic_email)
        assert_requested :get, staffomatic_url('/user')
      end
    end
  end

  describe ".agent" do
    before do
      Staffomatic.reset!
    end
    it "acts like a Sawyer agent" do
      expect(Staffomatic.client.agent).to respond_to :start
    end
    it "caches the agent" do
      agent = Staffomatic.client.agent
      expect(agent.object_id).to eq(Staffomatic.client.agent.object_id)
    end
  end # .agent

  describe ".root" do
    it "fetches the API root" do
      Staffomatic.reset!
      VCR.use_cassette 'root' do
        root = Staffomatic.client.root
        expect(root[:current_user_url]).to eq("#{test_staffomatic_api_endpoint}/user")
      end
    end
  end

  describe ".last_response", :vcr do
    it "caches the last agent response" do
      Staffomatic.reset!
      client = Staffomatic.client
      expect(client.last_response).to be_nil
      client.get "/api"
      expect(client.last_response.status).to eq(200)
    end
  end # .last_response

  describe ".get", :vcr do
    before(:each) do
      Staffomatic.reset!
      Staffomatic.api_endpoint = test_staffomatic_api_endpoint
    end
    it "handles query params" do
      Staffomatic.get "/api", :foo => "bar"
      assert_requested :get, "https://api.staffomaticapp.com/v3/demo/api?foo=bar"
    end
    it "handles headers" do
      request = stub_get("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Staffomatic.get "zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .get

  describe ".head", :vcr do
    it "handles query params" do
      Staffomatic.reset!
      Staffomatic.head "/api", :foo => "bar"
      assert_requested :head, "https://api.staffomaticapp.com/v3/demo/api?foo=bar"
    end
    it "handles headers" do
      Staffomatic.reset!
      request = stub_head("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Staffomatic.head "zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .head

  describe "when making requests" do
    before do
      Staffomatic.reset!
      @client = Staffomatic.client
    end
    it "Accepts application/vnd.staffomatic.v3+json by default" do
      VCR.use_cassette 'root' do
        root_request = stub_get("https://api.staffomaticapp.com/v3/demo/api").
          with(:headers => {:accept => "application/vnd.staffomatic.v3+json"})
        @client.get "/api"
        assert_requested root_request
        expect(@client.last_response.status).to eq(200)
      end
    end
    it "allows Accept'ing another media type" do
      root_request = stub_get("https://api.staffomaticapp.com/v3/demo/api").
        with(:headers => {:accept => "application/vnd.staffomatic.beta.diff+json"})
      @client.get "/api", :accept => "application/vnd.staffomatic.beta.diff+json"
      assert_requested root_request
      expect(@client.last_response.status).to eq(200)
    end
    it "sets a default user agent" do
      root_request = stub_get("https://api.staffomaticapp.com/v3/demo/api").
        with(:headers => {:user_agent => Staffomatic::Default.user_agent})
      @client.get "/api"
      assert_requested root_request
      expect(@client.last_response.status).to eq(200)
    end
    it "sets a custom user agent" do
      user_agent = "Mozilla/5.0 I am Spartacus!"
      root_request = stub_get("https://api.staffomaticapp.com/v3/demo/api").
        with(:headers => {:user_agent => user_agent})
      client = Staffomatic::Client.new(:user_agent => user_agent)
      client.get "/api"
      assert_requested root_request
      expect(client.last_response.status).to eq(200)
    end
    it "sets a proxy server" do
      Staffomatic.configure do |config|
        config.proxy = 'http://proxy.example.com:80'
      end
      conn = Staffomatic.client.send(:agent).instance_variable_get(:"@conn")
      expect(conn.proxy[:uri].to_s).to eq('http://proxy.example.com')
    end
    it "passes along request headers for POST" do
      headers = {"X-Staffomatic-Foo" => "bar"}
      root_request = stub_post("https://api.staffomaticapp.com/v3/demo/api").
        with(:headers => headers).
        to_return(:status => 201)
      client = Staffomatic::Client.new
      client.post "/api", :headers => headers
      assert_requested root_request
      expect(client.last_response.status).to eq(201)
    end
    it "adds app creds in query params to anonymous requests" do
      client = Staffomatic::Client.new
      client.client_id     = key = '97b4937b385eb63d1f46'
      client.client_secret = secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
      root_request = stub_get "https://api.staffomaticapp.com/v3/demo/api?client_id=#{key}&client_secret=#{secret}"

      client.get("/api")
      assert_requested root_request
    end
    it "omits app creds in query params for basic requests" do
      client = Staffomatic::Client.new :email => "admin@demo.de", :password => "passw0rd"
      client.client_id     = key = '97b4937b385eb63d1f46'
      client.client_secret = secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
      root_request = stub_get basic_staffomatic_url("/zen?foo=bar", :login => "login", :password => "passw0rd")

      client.get("/api/v3/zen", :foo => "bar")
      assert_requested root_request
    end
    it "omits app creds in query params for token requests" do
      client = Staffomatic::Client.new(:access_token => '87614b09dd141c22800f96f11737ade5226d7ba8')
      client.client_id     = key = '97b4937b385eb63d1f46'
      client.client_secret = secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
      root_request = stub_get(staffomatic_url("https://api.staffomaticapp.com/v3/demo/api?foo=bar")).with \
        :headers => {"Authorization" => "Bearer 87614b09dd141c22800f96f11737ade5226d7ba8"}

      client.get("/api", :foo => "bar")
      assert_requested root_request
    end
  end

  describe "auto pagination", :vcr do
    before do
      Staffomatic.reset!
      Staffomatic.configure do |config|
        config.auto_paginate = true
        config.per_page = 1
        config.access_token = test_staffomatic_token
        config.account = test_staffomatic_account
      end
    end

    after do
      Staffomatic.reset!
    end

    it "fetches all the pages" do
      url = '/api/v3/users'
      Staffomatic.client.paginate url
      assert_requested :get, staffomatic_url("#{url}?per_page=1")
      (2..3).each do |i|
        assert_requested :get, staffomatic_url("#{url}?per_page=1&page=#{i}")
      end
    end

    # we should now
    it "accepts a block for custom result concatination" do
      pending("not implemented yet.")
      results = Staffomatic.client.paginate("/api/v3/users?per_page=1",
        :per_page => 1) do |data, last_response|
        data.total = last_response.headers['total']
      end

      expect(results.total).to eq(2)
      expect(results.length).to eq(2)
    end
  end

  context "error handling" do
    before do
      Staffomatic.reset!
      VCR.turn_off!
    end

    after do
      VCR.turn_on!
    end

    it "raises on 404" do
      stub_get('/booya').to_return(:status => 404)
      expect { Staffomatic.get('/api/v3/booya') }.to raise_error Staffomatic::NotFound
    end

    it "raises on 500" do
      stub_get('/api/v3/boom').to_return(:status => 500)
      expect { Staffomatic.get('/api/v3/boom') }.to raise_error Staffomatic::InternalServerError
    end

    it "includes a message" do
      stub_get('/api/v3/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "No repository found for hubtopic"}.to_json
      begin
        Staffomatic.get('/api/v3/boom')
      rescue Staffomatic::UnprocessableEntity => e
        expect(e.message).to include("GET #{staffomatic_url('/api/v3/boom')}: 422 - No repository found")
      end
    end

    it "includes an error" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:error => "No repository found for hubtopic"}.to_json
      begin
        Staffomatic.get('/api/v3/boom')
      rescue Staffomatic::UnprocessableEntity => e
        expect(e.message).to include("GET #{staffomatic_url('/api/v3/boom')}: 422 - Error: No repository found")
      end
    end

    it "includes an error summary" do
      stub_get('/api/v3/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Validation Failed",
          :errors => [
            :resource => "Issue",
            :field    => "title",
            :code     => "missing_field"
          ]
        }.to_json
      begin
        Staffomatic.get('/api/v3/boom')
      rescue Staffomatic::UnprocessableEntity => e
        expect(e.message).to include("GET #{staffomatic_url('/api/v3/boom')}: 422 - Validation Failed")
        expect(e.message).to include("  resource: Issue")
        expect(e.message).to include("  field: title")
        expect(e.message).to include("  code: missing_field")
      end
    end

    it "exposes errors array" do
      stub_get('/api/v3/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Validation Failed",
          :errors => [
            :resource => "Issue",
            :field    => "title",
            :code     => "missing_field"
          ]
        }.to_json
      begin
        Staffomatic.get('/api/v3/boom')
      rescue Staffomatic::UnprocessableEntity => e
        expect(e.errors.first[:resource]).to eq("Issue")
        expect(e.errors.first[:field]).to eq("title")
        expect(e.errors.first[:code]).to eq("missing_field")
      end
    end

    it "knows the difference between Forbidden and rate limiting" do
      pending("rate limit not yet implemented")
      stub_get('/some/admin/stuffs').to_return(:status => 403)
      expect { Staffomatic.get('/some/admin/stuffs') }.to raise_error Staffomatic::Forbidden

      stub_get('/api/v3/users/mojomobo').to_return \
        :status => 403,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "API rate limit exceeded"}.to_json
      expect { Staffomatic.get('/api/v3/users/mojomobo') }.to raise_error Staffomatic::TooManyRequests

      stub_get('/api/v3/user').to_return \
        :status => 403,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "Maximum number of login attempts exceeded"}.to_json
      expect { Staffomatic.get('/api/v3/user') }.to raise_error Staffomatic::TooManyLoginAttempts
    end

    it "raises on unknown client errors" do
      stub_get('/api/v3/user').to_return \
        :status => 418,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "I'm a teapot"}.to_json
      expect { Staffomatic.get('/api/v3/user') }.to raise_error Staffomatic::ClientError
    end

    it "raises on unknown server errors" do
      stub_get('/api/v3/user').to_return \
        :status => 509,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "Bandwidth exceeded"}.to_json
      expect { Staffomatic.get('/api/v3/user') }.to raise_error Staffomatic::ServerError
    end

    it "handles documentation URLs in error messages" do
      stub_get('/api/v3/user').to_return \
        :status => 415,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Unsupported Media Type",
          :documentation_url => "http://developer.github.com/v3"
        }.to_json
      begin
        Staffomatic.get('/api/v3/user')
      rescue Staffomatic::UnsupportedMediaType => e
        msg = "415 - Unsupported Media Type"
        expect(e.message).to include(msg)
        expect(e.documentation_url).to eq("http://developer.github.com/v3")
      end
    end

    it "handles an error response with an array body" do
      stub_get('/api/v3/user').to_return \
        :status => 500,
        :headers => {
          :content_type => "application/json"
        },
        :body => [].to_json
      expect { Staffomatic.get('/api/v3/user') }.to raise_error Staffomatic::ServerError
    end
  end

  it "knows when to raise Unauthorized error" do
    stub_get('/users').to_return(:status => 401)
    expect { Staffomatic.get('users') }.to raise_error Staffomatic::Unauthorized
  end

end
