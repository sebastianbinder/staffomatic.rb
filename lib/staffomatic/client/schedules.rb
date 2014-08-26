module Staffomatic
  class Client

    # Methods for the Schedules API
    #
    # @see https://developer.github.com/v3/schedules/
    module Schedules

      # List all Staffomatic schedules
      #
      # This provides a dump of every schedules, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/schedules/#get-all-schedules
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic schedules.
      def all_schedules(options = {})
        paginate "schedules", options
      end

      # Get a single schedule
      #
      # @param schedule_id [Integer] Staffomatic schedule id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/schedules/#get-a-single-schedule
      # @example
      #   Staffomatic.user(493)
      def schedule(schedule_id, options = {})
        get "schedules/#{schedule_id}", options
      end

      # Update a schedule
      #
      # @param schedule_id [Integer] Staffomatic schedule id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-schedules
      # @example
      #   Staffomatic.update_schedules(:name => "Erik Michaels-Ober")
      def update_schedule(schedule_id, options)
        patch "schedules/#{schedule_id}", :schedule => options
      end

      # Publish a schedule
      #
      # @param schedule_id [Integer] Staffomatic schedule id.
      # @param options [Hash] A customizable set of options.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-schedules
      # @example
      #   Staffomatic.publish_schedule(123)
      def publish_schedule(schedule_id, options = {})
        patch "schedules/#{schedule_id}", :schedule => options.merge({:do => 'publish'})
      end

      # Republish a schedule
      #
      # @param schedule_id [Integer] Staffomatic schedule id.
      # @param options [Hash] A customizable set of options.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-schedules
      # @example
      #   Staffomatic.publish_schedule(123)
      def republish_schedule(schedule_id, options = {})
        patch "schedules/#{schedule_id}", :schedule => options.merge({:do => 'republish'})
      end

      # Bulk delete schedule shifts
      #
      # @param schedule_id [Integer] Staffomatic schedule id.
      # @param department_ids [Array] Staffomatic department ids.
      # @param options [Hash] A customizable set of options.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-schedules
      # @example
      #   Staffomatic.publish_schedule(123)
      def bulk_delete_schedule_shifts(schedule_id, department_ids = [], options = {})
        patch "schedules/#{schedule_id}", :schedule => options.merge({:do => 'bulk_destroy', :department_ids => department_ids})
      end

      # Import shifts from another schedule
      #
      # @param schedule_id [Integer] Staffomatic schedule id.
      # @param import_schedule_id [Integer] Staffomatic schedule id.
      # @param department_ids [Array] Staffomatic department ids.
      # @param options [Hash] A customizable set of options.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-schedules
      # @example
      #   Staffomatic.publish_schedule(123)
      def import_shifts_from_schedule(schedule_id, import_schedule_id, import_assignments = false, department_ids = [], options = {})
        patch "schedules/#{schedule_id}", :schedule => options.merge({:do => 'import_shifts', :import_schedule_id => import_schedule_id, :import_assignments => import_assignments, :department_ids => department_ids})
      end

      # Accepts applications in schedule
      #
      # @param schedule_id [Integer] Staffomatic schedule id.
      # @param respect_max_hours_per_month [Boolean] take the max hours per month of the user into account.
      # @param department_ids [Array] Staffomatic department ids.
      # @param user_ids [Array] Staffomatic user ids.
      # @param options [Hash] A customizable set of options.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-schedules
      # @example
      #   Staffomatic.publish_schedule(123)
      def accept_applications_in_schedule(schedule_id, respect_max_hours_per_month, department_ids = [], user_ids = [], options = {})
        patch "schedules/#{schedule_id}", :schedule => options.merge({:do => 'bulk_accept',
          :respect_max_hours_per_month => respect_max_hours_per_month,
          :department_ids => department_ids,
          :user_ids => user_ids
        })
      end

      # Create a schedule
      #
      # @param name [String] The name of your schedule
      # @return [Sawyer::Resource] Your newly created schedules
      # @see https://developer.github.com/v3/schedules/#create-an-schedules
      # @example Create a new Location
      #   Octokit.create_schedules()
      def create_schedule(location_id, options)
        post "locations/#{location_id}/schedules", :schedule => options
      end

      # Delete a single schedule
      #
      # @param schedule_id [Integer] A Staffomatic schedule
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/schedules/#delete-a-schedule
      # @example Delete the schedule #1194549
      #   Staffomatic.delete_schedule(1194549)
      def delete_schedule(schedule_id, options = {})
        boolean_from_response :delete, "schedules/#{schedule_id}", options
      end

    end
  end
end
