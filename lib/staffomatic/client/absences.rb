module Staffomatic
  class Client

    # Methods for the Absences API
    #
    # @see https://developer.github.com/v3/absences/
    module Absences

      # List all Staffomatic absences
      #
      # This provides a dump of every absences, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/absences/#get-all-absences
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic absences.
      def all_absences(options = {})
        paginate "absences", options
      end

      # List absences in location
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/absences/#get-location-absences
      #
      # @return [Array<Sawyer::Resource>] List of absences.
      def location_absences(location_id, options = {})
        paginate "locations/#{location_id}/absences", options
      end

      # Get a single absence
      #
      # @param absence_id [Integer] Staffomatic absence id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/absences/#get-a-single-absence
      # @example
      #   Staffomatic.user(493)
      def absence(absence_id, options = {})
        get "absences/#{absence_id}", options
      end

      # Update a absence
      #
      # @param absence_id [Integer] Staffomatic absence id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-absences
      # @example
      #   Staffomatic.update_absences(:name => "Erik Michaels-Ober")
      def update_absence(absence_id, options)
        patch "absences/#{absence_id}", :absence => options
      end

      # Approve! a absence
      #
      # @param absence_id [Integer] Staffomatic absence id.
      # @param options [Hash] A customizable set of options.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-absences
      # @example
      #   Staffomatic.publish_absence(123)
      def approve_absence(absence_id, options = {})
        patch "absences/#{absence_id}", :absence => options.merge({:do => 'approve'})
      end

      # Decline! a absence
      #
      # @param absence_id [Integer] Staffomatic absence id.
      # @param options [Hash] A customizable set of options.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-absences
      # @example
      #   Staffomatic.publish_absence(123)
      def decline_absence(absence_id, options = {})
        patch "absences/#{absence_id}", :absence => options.merge({:do => 'decline'})
      end

      # Create absence
      #
      # @param name [String] The name of your absence
      # @return [Sawyer::Resource] Your newly created absences
      # @see https://developer.github.com/v3/absences/#create-an-absences
      # @example Create a new Location
      #   Octokit.create_absences()
      def create_absence(options = {})
        post "absences", :absence => options
      end

      # Delete a single absence
      #
      # @param absence_id [Integer] A Staffomatic absence
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/absences/#delete-a-absence
      # @example Delete the absence #1194549
      #   Staffomatic.delete_absence(1194549)
      def delete_absence(absence_id, options = {})
        boolean_from_response :delete, "absences/#{absence_id}", options
      end

    end
  end
end
