module Staffomatic
  class Client

    # Methods for the SpecialDays API
    #
    # @see https://developer.github.com/v3/special_days/
    module SpecialDays

      # List all Staffomatic special_days
      #
      # This provides a dump of every special_days, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/special_days/#get-all-special_days
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic special_days.
      def all_special_days(options = {})
        paginate "special_days", options
      end

      # List all Staffomatic location special_days
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/special_days/#get-location-special-days
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic special_days.
      def location_special_days(location_id, options = {})
        paginate "locations/#{location_id}/special_days", options
      end

      # Get a single special_day
      #
      # @param special_day_id [Integer] Staffomatic special_day id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/special_days/#get-a-single-special_day
      # @example
      #   Staffomatic.user(493)
      def special_day(special_day_id, options = {})
        get "special_days/#{special_day_id}", options
      end

      # Update a special_day
      #
      # @param special_day_id [Integer] Staffomatic special_day id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-special_days
      # @example
      #   Staffomatic.update_special_days(:name => "Erik Michaels-Ober")
      def update_special_day(special_day_id, options)
        patch "special_days/#{special_day_id}", options
      end

      # Create a special_day
      #
      # @param name [String] The name of your special_day
      # @return [Sawyer::Resource] Your newly created special_days
      # @see https://developer.github.com/v3/special_days/#create-an-special_days
      # @example Create a new Location
      #   Octokit.create_special_days()
      def create_special_day(location_id, options)
        post "locations/#{location_id}/special_days", options
      end

      # Delete a single special_day
      #
      # @param special_day_id [Integer] A Staffomatic special_day
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/special_days/#delete-a-special_day
      # @example Delete the special_day #1194549
      #   Staffomatic.delete_special_day(1194549)
      def delete_special_day(special_day_id, options = {})
        boolean_from_response :delete, "special_days/#{special_day_id}", options
      end

    end
  end
end
