module Staffomatic
  class Client

    # Methods for the AbsenceTypes API
    #
    # @see https://developer.github.com/v3/absence_types/
    module AbsenceTypes

      # List all Staffomatic absence_types
      #
      # This provides a dump of every absence_types, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/absence_types/#get-all-absence_types
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic absence_types.
      def all_absence_types(options = {})
        paginate "absence_types", options
      end
      alias absence_types all_absence_types

      # List all Staffomatic location absence_types
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/absence_types/#get-location-absence-types
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic absence_types.
      def location_absence_types(location_id, options = {})
        paginate "locations/#{location_id}/absence_types", options
      end

      # Get a single absence_type
      #
      # @param absence_type_id [Integer] Staffomatic absence_type id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/absence_types/#get-a-single-absence_type
      # @example
      #   Staffomatic.user(493)
      def absence_type(absence_type_id, options = {})
        get "absence_types/#{absence_type_id}", options
      end

      # Update a absence_type
      #
      # @param absence_type_id [Integer] Staffomatic absence_type id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-absence_types
      # @example
      #   Staffomatic.update_absence_types(:name => "Erik Michaels-Ober")
      def update_absence_type(absence_type_id, options)
        patch "absence_types/#{absence_type_id}", options
      end

      # Create a absence_type
      #
      # @param name [String] The name of your absence_type
      # @return [Sawyer::Resource] Your newly created absence_types
      # @see https://developer.github.com/v3/absence_types/#create-an-absence_types
      # @example Create a new Location
      #   Octokit.create_absence_types()
      def create_absence_type(location_id, options)
        post "locations/#{location_id}/absence_types", options
      end

      # Delete a single absence_type
      #
      # @param absence_type_id [Integer] A Staffomatic absence_type
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/absence_types/#delete-a-absence_type
      # @example Delete the absence_type #1194549
      #   Staffomatic.delete_absence_type(1194549)
      def delete_absence_type(absence_type_id, options = {})
        boolean_from_response :delete, "absence_types/#{absence_type_id}", options
      end

    end
  end
end
