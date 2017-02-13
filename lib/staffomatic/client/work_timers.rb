module Staffomatic
  class Client

    # Methods for the SpecialDays API
    #
    # @see https://developer.github.com/v3/work_timers/
    module WorkTimers

      # List all Staffomatic work_timers
      #
      # This provides a dump of every work_timers, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/work_timers/#get-all-work_timers
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic work_timers.
      def all_work_timers(options = {})
        paginate "work_timers", options
      end

      # List all Staffomatic location work_timers
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/work_timers/#get-location-special-days
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic work_timers.
      def location_work_timers(location_id, options = {})
        paginate "locations/#{location_id}/work_timers", options
      end

      # Get a single work_timer
      #
      # @param work_timer_id [Integer] Staffomatic work_timer id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/work_timers/#get-a-single-work_timer
      # @example
      #   Staffomatic.user(493)
      def work_timer(work_timer_id, options = {})
        get "work_timers/#{work_timer_id}", options
      end

      # Update a work_timer
      #
      # @param work_timer_id [Integer] Staffomatic work_timer id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-work_timers
      # @example
      #   Staffomatic.update_work_timers(:name => "Erik Michaels-Ober")
      def update_work_timer(work_timer_id, options)
        patch "work_timers/#{work_timer_id}", options
      end

      # Create a work_timer
      #
      # @param options [String] Options to create work_timer
      # @return [Sawyer::Resource] Your newly created work_timer
      # @see https://developer.github.com/v3/work_timers/#create-an-work_timers
      # @example Create a new WorkTimer
      #   Octokit.create_work_timers(...)
      def create_work_timer(options)
        post "work_timers", options
      end

      # Delete a single work_timer
      #
      # @param work_timer_id [Integer] A Staffomatic work_timer
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/work_timers/#delete-a-work_timer
      # @example Delete the work_timer #92
      #   Staffomatic.delete_work_timer(92)
      def delete_work_timer(work_timer_id, options = {})
        boolean_from_response :delete, "work_timers/#{work_timer_id}", options
      end

    end
  end
end
