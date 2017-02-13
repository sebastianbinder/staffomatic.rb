module Staffomatic
  class Client

    # Methods for the SpecialDays API
    #
    # @see https://developer.github.com/v3/break_timers/
    module BreakTimers

      # List all Staffomatic break_timers
      #
      # This provides a dump of every break_timers, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/break_timers/#get-all-break_timers
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic break_timers.
      def all_break_timers(options = {})
        paginate "break_timers", options
      end

      # List all Staffomatic location break_timers
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/break_timers/#get-location-special-days
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic break_timers.
      def work_timer_breaks(work_timer_id, options = {})
        paginate "work_timers/#{work_timer_id}/break_timers", options
      end

      # Get a single break_timer
      #
      # @param break_timer_id [Integer] Staffomatic break_timer id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/break_timers/#get-a-single-break_timer
      # @example
      #   Staffomatic.user(493)
      def break_timer(break_timer_id, options = {})
        get "break_timers/#{break_timer_id}", options
      end

      # Update a break_timer
      #
      # @param break_timer_id [Integer] Staffomatic break_timer id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-break_timers
      # @example
      #   Staffomatic.update_break_timers(:name => "Erik Michaels-Ober")
      def update_break_timer(break_timer_id, options)
        patch "break_timers/#{break_timer_id}", options
      end

      # Create a break_timer
      #
      # @param options [String] Options to create break_timer
      # @return [Sawyer::Resource] Your newly created break_timer
      # @see https://developer.github.com/v3/break_timers/#create-an-break_timers
      # @example Create a new BreakTimer
      #   Octokit.create_break_timers(...)
      def create_break_timer(work_timer_id, options)
        post "work_timers/#{work_timer_id}/break_timers", options
      end

      # Delete a single break_timer
      #
      # @param break_timer_id [Integer] A Staffomatic break_timer
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/break_timers/#delete-a-break_timer
      # @example Delete the break_timer #92
      #   Staffomatic.delete_break_timer(92)
      def delete_break_timer(break_timer_id, options = {})
        boolean_from_response :delete, "break_timers/#{break_timer_id}", options
      end

    end
  end
end
