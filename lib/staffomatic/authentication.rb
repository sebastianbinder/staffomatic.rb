module Staffomatic

  # Authentication methods for {Staffomatic::Client}
  module Authentication

    # Indicates if the client was supplied  Basic Auth
    # email, password
    #
    # @see https://developer.github.com/v3/#authentication
    # @return [Boolean]
    def basic_authenticated?
      !!(@email && @password)
    end

    # Indicates if the client was supplied an OAuth
    # access token
    #
    # @see https://developer.github.com/v3/#authentication
    # @return [Boolean]
    def token_authenticated?
      !!@access_token
    end

    # Indicates if the client was supplied an OAuth
    # access token or Basic Auth email and password
    #
    # @see https://developer.github.com/v3/#authentication
    # @return [Boolean]
    def user_authenticated?
      basic_authenticated? || token_authenticated?
    end

    # Indicates if the client has OAuth Application
    # client_id and secret credentials to make anonymous
    # requests at a higher rate limit
    #
    # @see https://developer.github.com/v3/#unauthenticated-rate-limited-requests
    # @return Boolean
    def application_authenticated?
      !!application_authentication
    end

    private

    def application_authentication
      if @client_id && @client_secret
        {
          :client_id     => @client_id,
          :client_secret => @client_secret
        }
      end
    end

  end
end
