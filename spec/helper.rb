require 'cgi'
require 'minitest/autorun'
require 'minitest/spec'
require 'webmock'
require 'staffomatic'

module SpecHelper
  include WebMock::API

  def stub_api_request method, uri, fixture = nil
    uri = API.base_uri + uri
    uri.user = CGI.escape Recurly.api_key
    uri.password = ''
    response = if block_given?
      yield
    else
      File.read File.expand_path("../fixtures/#{fixture}.xml", __FILE__)
    end
    stub_request(method, uri.to_s).to_return response
  end
end
include SpecHelper
