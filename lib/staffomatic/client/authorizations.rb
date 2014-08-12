module Staffomatic
  class Client

    # Methods for the Authorizations API
    #
    # @see https://developer.github.com/v3/oauth_authorizations/#oauth-authorizations-api
    module Authorizations

      # List the authenticated user's authorizations
      #
      # API for users to manage their own tokens.
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # @return [Array<Sawyer::Resource>] A list of authorizations for the authenticated user
      # @see https://developer.github.com/v3/oauth_authorizations/#list-your-authorizations
      # @example List authorizations for user ctshryock
      #  client = Staffomatic::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.authorizations
      def authorizations(options = {})
        paginate 'authorizations', options
      end

      # Get a single authorization for the authenticated user.
      #
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # @return [Sawyer::Resource] A single authorization for the authenticated user
      # @see https://developer.github.com/v3/oauth_authorizations/#get-a-single-authorization
      # @example Show authorization for user ctshryock's Travis auth
      #  client = Staffomatic::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.authorization(999999)
      def authorization(number, options = {})
        get "authorizations/#{number}", options
      end

      # Update an authorization for the authenticated user.
      #
      # You can update your own tokens, but only through
      # Basic Authentication.
      #
      # @param options [Hash] A customizable set of options.
      # @option options [Array] :scopes Replace the authorization scopes with these.
      # @option options [Array] :add_scopes A list of scopes to add to this authorization.
      # @option options [Array] :remove_scopes A list of scopes to remove from this authorization.
      # @option options [String] :note A note to remind you what the OAuth token is for.
      # @option options [String] :note_url A URL to remind you what app the OAuth token is for.
      #
      # @return [Sawyer::Resource] A single (updated) authorization for the authenticated user
      # @see https://developer.github.com/v3/oauth_authorizations/#update-an-existing-authorization
      # @see https://developer.github.com/v3/oauth/#scopes for available scopes
      # @example Update the authorization for user ctshryock's project Zoidberg
      #  client = Staffomatic::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.update_authorization(999999, {:add_scopes => ["gist", "repo"], :note => "Why not Zoidberg possibly?"})
      def update_authorization(number, options = {})
        patch "authorizations/#{number}", options
      end

      # Delete an authorization for the authenticated user.
      #
      # You can delete your own tokens, and only through
      # Basic Authentication.
      #
      # @param number [Number] An existing Authorization ID
      #
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/oauth_authorizations/#delete-an-authorization
      # @example Delete an authorization
      #  client = Staffomatic::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.delete_authorization(999999)
      def delete_authorization(number, options = {})
        boolean_from_response :delete, "authorizations/#{number}", options
      end

      # Check scopes for a token
      #
      # @param token [String] Staffomatic OAuth token
      # @return [Array<String>] OAuth scopes
      # @see https://developer.github.com/v3/oauth/#scopes
      def scopes(token = @access_token)
        raise ArgumentError.new("Access token required") if token.nil?

        agent.call(:get, "user", :headers => {"Authorization" => "access_token #{token}" }).
          headers['X-OAuth-Scopes'].
          to_s.
          split(',').
          map(&:strip).
          sort
      end

      # Check if a token is valid.
      #
      # Applications can check if a token is valid without rate limits.
      #
      # @param token [String] 40 character Staffomatic OAuth access token
      #
      # @return [Sawyer::Resource] A single authorization for the authenticated user
      # @see https://developer.github.com/v3/oauth_authorizations/#check-an-authorization
      # @example
      #  client = Staffomatic::Client.new(:client_id => 'abcdefg12345', :client_secret => 'secret')
      #  client.check_application_authorization('deadbeef1234567890deadbeef987654321')
      def check_application_authorization(token, options = {})
        opts = options.dup
        key    = opts.delete(:client_id)     || client_id
        secret = opts.delete(:client_secret) || client_secret

        as_app(key, secret) do |app_client|
          app_client.get "/applications/#{client_id}/tokens/#{token}", opts
        end
      end

      # Reset a token
      #
      # Applications can reset a token without requiring a user to re-authorize.
      #
      # @param token [String] 40 character Staffomatic OAuth access token
      #
      # @return [Sawyer::Resource] A single authorization for the authenticated user
      # @see https://developer.github.com/v3/oauth_authorizations/#reset-an-authorization
      # @example
      #  client = Staffomatic::Client.new(:client_id => 'abcdefg12345', :client_secret => 'secret')
      #  client.reset_application_authorization('deadbeef1234567890deadbeef987654321')
      def reset_application_authorization(token, options = {})
        opts = options.dup
        key    = opts.delete(:client_id)     || client_id
        secret = opts.delete(:client_secret) || client_secret

        as_app(key, secret) do |app_client|
          app_client.post "/applications/#{client_id}/tokens/#{token}", opts
        end
      end

      # Revoke a token
      #
      # Applications can revoke (delete) a token
      #
      # @param token [String] 40 character Staffomatic OAuth access token
      #
      # @return [Boolean] Result
      # @see https://developer.github.com/v3/oauth_authorizations/#revoke-an-authorization-for-an-application
      # @example
      #  client = Staffomatic::Client.new(:client_id => 'abcdefg12345', :client_secret => 'secret')
      #  client.revoke_application_authorization('deadbeef1234567890deadbeef987654321')
      def revoke_application_authorization(token, options = {})
        opts = options.dup
        key    = opts.delete(:client_id)     || client_id
        secret = opts.delete(:client_secret) || client_secret

        as_app(key, secret) do |app_client|
          app_client.delete "/applications/#{client_id}/tokens/#{token}", opts

          app_client.last_response.status == 204
        end
      rescue Staffomatic::NotFound
        false
      end
      alias :delete_application_authorization :revoke_application_authorization

      # Revoke all tokens for an app
      #
      # Applications can revoke all of their tokens in a single request
      #
      # @return [Boolean] Result
      # @see https://developer.github.com/v3/oauth_authorizations/#revoke-all-authorizations-for-an-application
      # @example
      #  client = Staffomatic::Client.new(:client_id => 'abcdefg12345', :client_secret => 'secret')
      #  client.revoke_all_application_authorizations
      def revoke_all_application_authorizations(options = {})
        opts = options.dup
        key    = opts.delete(:client_id)     || client_id
        secret = opts.delete(:client_secret) || client_secret

        as_app(key, secret) do |app_client|
          app_client.delete "/applications/#{client_id}/tokens", opts

          app_client.last_response.status == 204
        end
      rescue Staffomatic::NotFound
        false
      end
      alias :delete_application_authorization :revoke_application_authorization

      # Get the URL to authorize a user for an application via the web flow
      #
      # @param app_id [String] Client Id we received when our application was registered with Staffomatic.
      # @option options [String] :redirect_uri The url to redirect to after authorizing.
      # @option options [String] :scope The scopes to request from the user.
      # @option options [String] :state A random string to protect against CSRF.
      # @return [String] The url to redirect the user to authorize.
      # @see Staffomatic::Client
      # @see https://developer.github.com/v3/oauth/#web-application-flow
      # @example
      #   @client.authorize_url('xxxx')
      def authorize_url(app_id = client_id, options = {})
        if app_id.to_s.empty?
          raise Staffomatic::ApplicationCredentialsRequired.new "client_id required"
        end
        authorize_url = options.delete(:api_endpoint) || Staffomatic.api_endpoint
        authorize_url += "oauth/authorize?client_id=" + app_id

        options.each do |key, value|
          authorize_url += "&" + key.to_s + "=" + value
        end

        authorize_url
      end
    end
  end
end
