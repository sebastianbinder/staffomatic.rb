if RUBY_ENGINE == 'ruby'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start
end

require 'json'
require 'staffomatic'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.before(:all) do
    @test_repo = "#{test_staffomatic_email}/#{test_staffomatic_repository}"
    @test_org_repo = "#{test_staffomatic_org}/#{test_staffomatic_repository}"
  end
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<GITHUB_LOGIN>") do
    test_staffomatic_email
  end
  c.filter_sensitive_data("<GITHUB_PASSWORD>") do
    test_staffomatic_password
  end
  c.filter_sensitive_data("<<ACCESS_TOKEN>>") do
    test_staffomatic_token
  end
  c.filter_sensitive_data("<GITHUB_CLIENT_ID>") do
    test_staffomatic_client_id
  end
  c.filter_sensitive_data("<GITHUB_CLIENT_SECRET>") do
    test_staffomatic_client_secret
  end
  c.define_cassette_placeholder("<GITHUB_TEST_REPOSITORY>") do
    test_staffomatic_repository
  end
  c.define_cassette_placeholder("<GITHUB_TEST_ORGANIZATION>") do
    test_staffomatic_org
  end
  c.define_cassette_placeholder("<GITHUB_TEST_ORG_TEAM_ID>") do
    "10050505050000"
  end

  c.before_http_request(:real?) do |request|
    next if request.headers['X-Vcr-Test-Repo-Setup']
    next unless request.uri.include? test_staffomatic_repository

    options = {
      :headers => {'X-Vcr-Test-Repo-Setup' => 'true'},
      :auto_init => true
    }

    test_repo = "#{test_staffomatic_email}/#{test_staffomatic_repository}"
    if !oauth_client.repository?(test_repo, options)
      Staffomatic.staffomatic_warn "NOTICE: Creating #{test_repo} test repository."
      oauth_client.create_repository(test_staffomatic_repository, options)
    end

    test_org_repo = "#{test_staffomatic_org}/#{test_staffomatic_repository}"
    if !oauth_client.repository?(test_org_repo, options)
      Staffomatic.staffomatic_warn "NOTICE: Creating #{test_org_repo} test repository."
      options[:organization] = test_staffomatic_org
      oauth_client.create_repository(test_staffomatic_repository, options)
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
  ENV.fetch 'STAFFOMATIC_TEST_EMAIL', 'api-padawan'
end

def test_staffomatic_password
  ENV.fetch 'STAFFOMATIC_TEST_PASSWORD', 'wow_such_password'
end

def test_staffomatic_subdomain
  ENV.fetch 'STAFFOMATIC_TEST_SUBDOMAIN', 'demo'
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

def test_staffomatic_repository
  ENV.fetch 'STAFFOMATIC_TEST_REPOSITORY', 'api-sandbox'
end

def test_staffomatic_org
  ENV.fetch 'STAFFOMATIC_TEST_ORGANIZATION', 'api-playground'
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

  url = File.join(Staffomatic.api_endpoint, url)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")

  uri.to_s
end

def basic_staffomatic_url(path, options = {})
  url = File.join(Staffomatic.api_endpoint, path)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")

  uri.user     = options.fetch(:email, test_staffomatic_email)
  uri.password = options.fetch(:password, test_staffomatic_password)
  uri.to_s
end

def basic_auth_client(email = test_staffomatic_email, password = test_staffomatic_password, subdomain = test_staffomatic_subdomain)
  client = Staffomatic.client
  client.email = test_staffomatic_email
  client.password = test_staffomatic_password
  client.subdomain = test_staffomatic_subdomain

  client
end

def oauth_client
  Staffomatic::Client.new(:access_token => test_staffomatic_token)
end

def use_vcr_placeholder_for(text, replacement)
  VCR.configure do |c|
    c.define_cassette_placeholder(replacement) do
      text
    end
  end
end
