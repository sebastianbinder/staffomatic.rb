module Staffomatic
  class Client

    # Methods for the Users API
    #
    # @see https://developer.github.com/v3/users/
    module Account

      # Get a single account
      #
      #   Staffomatic.account
      def get_account
        get 'account'
      end

      # Update the account
      #
      # @param options [Hash] A customizable set of options.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-user
      # @example
      #   Staffomatic.update_account(:name => "Erik Michaels-Ober")
      def update_account(options)
        patch 'account', options
      end

    end

  end
end
