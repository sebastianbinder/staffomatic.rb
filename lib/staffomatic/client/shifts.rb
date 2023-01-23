module Staffomatic
  class Client

    # Methods for the Schedules API
    #
    # @see https://developer.github.com/v3/shifts/
    module Shifts

      # List all Staffomatic shifts
      #
      # This provides a dump of every shifts, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/shifts/#get-all-shifts
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic shifts.
      def all_shifts(options = {})
        paginate "shifts", options
      end
      alias shifts all_shifts

      # List all location shifts
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/shifts/#get-all-shifts
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic shifts.
      def location_shifts(location_id, options = {})
        paginate "locations/#{location_id}/shifts", options
      end

      # List all schedule shifts
      #
      # @param schedule_id [Integer] Schedule id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/shifts/#get-all-shifts
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic shifts.
      def schedule_shifts(schedule_id, options = {})
        paginate "schedules/#{schedule_id}/shifts", options
      end

      # Get a single shift
      #
      # @param shift_id [Integer] Staffomatic shift id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/shifts/#get-a-single-shift
      # @example
      #   Staffomatic.user(493)
      def shift(shift_id, options = {})
        get "shifts/#{shift_id}", options
      end

      # Update a shift
      #
      # @param shift_id [Integer] Staffomatic shift id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-shifts
      # @example
      #   Staffomatic.update_shifts(:name => "Erik Michaels-Ober")
      def update_shift(shift_id, options)
        patch "shifts/#{shift_id}", options
      end

      # Create a shift
      #
      # @param name [String] The name of your shift
      # @return [Sawyer::Resource] Your newly created shifts
      # @see https://developer.github.com/v3/shifts/#create-an-shifts
      # @example Create a new Location
      #   Octokit.create_shifts()
      def create_shift(schedule_id, department_id, options)
        post "schedules/#{schedule_id}/shifts", options.merge(:department_id => department_id)
      end

      # Delete a single shift
      #
      # @param shift_id [Integer] A Staffomatic shift
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/shifts/#delete-a-shift
      # @example Delete the shift #1194549
      #   Staffomatic.delete_shift(1194549)
      def delete_shift(shift_id, options = {})
        boolean_from_response :delete, "shifts/#{shift_id}", options
      end

    end
  end
end
