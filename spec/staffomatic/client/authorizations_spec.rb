require 'helper'

describe Staffomatic::Client::Authorizations do

  before do
    Staffomatic.reset!
    @client = basic_auth_client

    @app_client = Staffomatic::Client.new \
      :client_id     => test_staffomatic_client_id,
      :client_secret => test_staffomatic_client_secret
  end

  after do
    Staffomatic.reset!
  end

end
