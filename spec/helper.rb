if RUBY_ENGINE == 'ruby'
  require 'simplecov'
  require 'coveralls'

  #SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  #  SimpleCov::Formatter::HTMLFormatter,
  #  Coveralls::SimpleCov::Formatter
  #]
  #SimpleCov.start
end

require 'json'
require 'staffomatic'
require 'rspec'
require 'webmock/rspec'

def default_env_file
  ::File.join(Dir.getwd, '.env')
end

def set_env
  envfile = default_env_file
  ::File.readlines(envfile).each {|line|
    next if line.chomp == "" || line =~ /^#/
    parts = line.chomp.split('=')
    ENV[parts[0]] = parts[1..-1].join('=')
  } if ::File.exist?(envfile)
end

set_env


WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.raise_errors_for_deprecations!
  config.before(:all) do
    @test_repo = "#{test_staffomatic_email}/#{test_staffomatic_location}"
    @test_org_repo = "#{test_staffomatic_account}/#{test_staffomatic_location}"
  end
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<STAFFOMATIC_EMAIL>") do
    test_staffomatic_email
  end
  c.filter_sensitive_data("<STAFFOMATIC_PASSWORD>") do
    test_staffomatic_password
  end
  c.filter_sensitive_data("<<ACCESS_TOKEN>>") do
    test_staffomatic_token
  end
  c.filter_sensitive_data("<STAFFOMATIC_CLIENT_ID>") do
    test_staffomatic_client_id
  end
  c.filter_sensitive_data("<STAFFOMATIC_CLIENT_SECRET>") do
    test_staffomatic_client_secret
  end
  c.define_cassette_placeholder("<STAFFOMATIC_TEST_LOCATION>") do
    test_staffomatic_location
  end
  c.define_cassette_placeholder("<STAFFOMATIC_TEST_ACCOUNT>") do
    test_staffomatic_account
  end

  c.before_http_request(:real?) do |request|
    next if request.headers['X-Vcr-Test-Repo-Setup']
    next unless request.uri.include? test_staffomatic_location

    options = {
      :headers => {'X-Vcr-Test-Location-Setup' => 'true'},
      :auto_init => true
    }

    test_repo = "#{test_staffomatic_email}/#{test_staffomatic_location}"
    if !oauth_client.repository?(test_repo, options)
      Staffomatic.staffomatic_warn "NOTICE: Creating #{test_repo} test repository."
      oauth_client.create_repository(test_staffomatic_location, options)
    end

    test_org_repo = "#{test_staffomatic_account}/#{test_staffomatic_location}"
    if !oauth_client.repository?(test_org_repo, options)
      Staffomatic.staffomatic_warn "NOTICE: Creating #{test_org_repo} test repository."
      options[:organization] = test_staffomatic_account
      oauth_client.create_repository(test_staffomatic_location, options)
    end
  end

  c.ignore_request do |request|
    !!request.headers['X-Vcr-Test-Repo-Setup']
  end

  c.default_cassette_options = {
    :serialize_with             => :json,
    # TODO: Track down UTF-8 issue and remove
    :preserve_exact_body_bytes  => true,
    :decode_compressed_response => true,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def test_staffomatic_email
  ENV.fetch 'STAFFOMATIC_TEST_EMAIL', 'admin@example.com'
end

def test_staffomatic_password
  ENV.fetch 'STAFFOMATIC_TEST_PASSWORD', 'supersafepassword'
end

# always with version specification
def test_staffomatic_api_endpoint
  ENV.fetch 'STAFFOMATIC_TEST_API_ENDPOINT', "https://api.staffomaticapp.com/v3/#{test_staffomatic_account}"
end

# always with version specification
def test_staffomatic_account
  ENV.fetch 'STAFFOMATIC_TEST_ACCOUNT', 'example-account-subdoamin'
end

def test_staffomatic_token
  ENV.fetch 'STAFFOMATIC_TEST_TOKEN', 'x' * 40
end

def test_staffomatic_client_id
  ENV.fetch 'STAFFOMATIC_TEST_CLIENT_ID', 'x' * 21
end

def test_staffomatic_client_secret
  ENV.fetch 'STAFFOMATIC_TEST_CLIENT_SECRET', 'x' * 40
end

def test_staffomatic_location
  ENV.fetch 'STAFFOMATIC_TEST_LOCATION', 'api-sandbox'
end

def test_staffomatic_account
  ENV.fetch 'STAFFOMATIC_TEST_ACCOUNT', 'example-account-subdoamin'
end

def test_staffomatic_scheme
  ENV.fetch 'STAFFOMATIC_TEST_SCHEME', 'http'
end

def stub_delete(url)
  stub_request(:delete, staffomatic_url(url))
end

def stub_get(url)
  stub_request(:get, staffomatic_url(url))
end

def stub_head(url)
  stub_request(:head, staffomatic_url(url))
end

def stub_patch(url)
  stub_request(:patch, staffomatic_url(url))
end

def stub_post(url)
  stub_request(:post, staffomatic_url(url))
end

def stub_put(url)
  stub_request(:put, staffomatic_url(url))
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end

def staffomatic_url(url)
  return url if url =~ /^http/
  url.gsub!("/api/v3", "")
  url = File.join(test_staffomatic_api_endpoint, url)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")
  uri.to_s
end

def basic_staffomatic_url(path, options = {})
  url = File.join(test_staffomatic_api_endpoint, path)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")

  uri.user     = options.fetch(:email, test_staffomatic_email)
  uri.password = options.fetch(:password, test_staffomatic_password)
  uri.to_s
end

def basic_auth_client(email = test_staffomatic_email, password = test_staffomatic_password)
  client = Staffomatic.client
  client.email = test_staffomatic_email
  client.password = test_staffomatic_password

  client
end

def oauth_client
  Staffomatic::Client.new(
    :access_token => test_staffomatic_token,
    :account => test_staffomatic_account,
    :scheme => test_staffomatic_scheme
  )
end

def use_vcr_placeholder_for(text, replacement)
  VCR.configure do |c|
    c.define_cassette_placeholder(replacement) do
      text
    end
  end
end
