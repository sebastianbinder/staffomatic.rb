module Staffomatic
  class Client

    # Methods for the Locations API
    #
    # @see https://developer.github.com/v3/locations/
    module Locations

      # List all Staffomatic locations
      #
      # This provides a dump of every locations, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/locations/#get-all-locations
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic locations.
      def all_locations(options = {})
        paginate "locations", options
      end

      # Get a single location
      #
      # @param location_id [Integer] Staffomatic location id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/locations/#get-a-single-location
      # @example
      #   Staffomatic.user(493)
      def location(location_id, options = {})
        get "locations/#{location_id}", options
      end

      # Update a location
      #
      # @param location_id [Integer] Staffomatic location id.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-locations
      # @example
      #   Staffomatic.update_locations(:name => "Erik Michaels-Ober")
      def update_location(location_id, options)
        patch "locations/#{location_id}", :location => options
      end

      # Create a location
      #
      # @param name [String] The name of your location
      # @return [Sawyer::Resource] Your newly created locations
      # @see https://developer.github.com/v3/locations/#create-an-locations
      # @example Create a new Location
      #   Octokit.create_locations()
      def create_location(name, options = {})
        post "locations", :location => options.merge({:name => name})
      end

      # Delete a single location
      #
      # @param repo [Integer] A Staffomatic location
      # @param location_id [Integer] location id.
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/locations/#delete-a-location
      # @example Delete the location #1194549
      #   Staffomatic.delete_location(1194549)
      def delete_location(location_id, options = {})
        boolean_from_response :delete, "locations/#{location_id}", options
      end

    end
  end
end
