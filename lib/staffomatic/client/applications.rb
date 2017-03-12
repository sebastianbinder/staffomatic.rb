module Staffomatic
  class Client

    # Methods for the Applications API
    #
    # @see https://developer.staffomatic.com/v3/applications/
    module Applications

      # List all Staffomatic applications
      #
      # This provides a dump of every applications, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.staffomatic.com/v3/applications/#get-all-applications
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic applications.
      def all_applications(options = {})
        paginate "applications", options
      end

      def location_applications(location_id, options = {})
        paginate "locations/#{location_id}/applications", options
      end

      def schedule_applications(schedule_id, options = {})
        paginate "schedules/#{schedule_id}/applications", options
      end

      def shift_applications(shift_id, options = {})
        paginate "shifts/#{shift_id}/applications", options
      end

      # Get a single application
      #
      # @param application_id [Integer] Staffomatic application id.
      # @return [Sawyer::Resource]
      # @see https://developer.staffomatic.com/v3/applications/#get-a-single-application
      # @example
      #   Staffomatic.user(493)
      def application(application_id, options = {})
        get "applications/#{application_id}", options
      end

      # Update a application
      #
      # @param application_id [Integer] Staffomatic application id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.staffomatic.com/v3/applications/#update-an-applications
      # @example
      #   Staffomatic.update_applications(:name => "Erik Michaels-Ober")
      def update_application(application_id, options)
        patch "applications/#{application_id}", options
      end

      # Accept! an applied application
      #
      # @param application_id [Integer] Staffomatic application id.
      # @return [Sawyer::Resource]
      # @see https://developer.staffomatic.com/v3/applications/#accept-an-applications
      # @example
      #   Staffomatic.accept_application(123123)
      def accept_application(application_id, options = {})
        patch "applications/#{application_id}", :application => options.merge(:do => 'accept')
      end

      # Revert! an assigned application
      #
      # @param application_id [Integer] Staffomatic application id.
      # @return [Sawyer::Resource]
      # @see https://developer.staffomatic.com/v3/applications/#revert-an-applications
      # @example
      #   Staffomatic.revert_application(123123)
      def revert_application(application_id, options = {})
        patch "applications/#{application_id}", :application => options.merge(:do => 'revert')
      end

      # Cancel! an assigned application
      #
      # @param application_id [Integer] Staffomatic application id.
      # @param cancel_reason [Text] Cancel reason to provide to the schedulers.
      # @return [Sawyer::Resource]
      # @see https://developer.staffomatic.com/v3/applications/#cancel-an-applications
      # @example
      #   Staffomatic.revert_application(123123)
      def cancel_application(application_id, cancel_reason, options = {})
        patch "applications/#{application_id}", :application => options.merge(:do => 'cancel', :cancel_reason => cancel_reason)
      end

      # Revoke! `cancelled` application
      #
      # @param application_id [Integer] Staffomatic application id.
      # @return [Sawyer::Resource]
      # @see https://developer.staffomatic.com/v3/applications/#revoke-an-applications
      # @example
      #   Staffomatic.revert_application(123123)
      def revoke_cancelled_application(application_id, options = {})
        patch "applications/#{application_id}", :application => options.merge(:do => 'revoke')
      end

      # Remove! or Reject! an applied application
      #
      # @param application_id [Integer] Staffomatic application id.
      # @return [Sawyer::Resource]
      # @see https://developer.staffomatic.com/v3/applications/#reject-an-applications
      # @example
      #   Staffomatic.revert_application(123123)
      def reject_application(application_id, options = {})
        patch "applications/#{application_id}", :application => options.merge(:do => 'reject')
      end

      # Supersede! a `canceled` application.
      #
      # @param application_id [Integer] Staffomatic application id.
      # @return [Sawyer::Resource]
      # @see https://developer.staffomatic.com/v3/applications/#supersede-an-applications
      # @example
      #   Staffomatic.supersede_application(123123)
      def supersede_application(application_id, options = {})
        patch "applications/#{application_id}", :application => options.merge(:do => 'supersede')
      end

      # Create an applied application
      #
      # @param shift_id [Integer] The id for the shift you want to create an applied application for.
      # @param user_id [Integer] The id of the user
      # @return [Sawyer::Resource] Your newly created applications
      # @see https://developer.staffomatic.com/v3/applications/#create-an-applications
      # @example Create a new Location
      #   Octokit.create_applied_application()
      def create_applied_application(shift_id, user_id, options = {})
        post "shifts/#{shift_id}/applications", :application => options.merge({:user_id => user_id, :do => 'apply'})
      end

      # Create an assigned application
      #
      # @param shift_id [Integer] The id for the shift you want to create an applied application for.
      # @param user_id [Integer] The id of the user
      # @return [Sawyer::Resource] Your newly created applications
      # @see https://developer.staffomatic.com/v3/applications/#create-an-applications
      # @example Create a new Location
      #   Octokit.create_applied_application()
      def create_assigned_application(shift_id, user_id, options = {})
        post "shifts/#{shift_id}/applications", :application => options.merge({:user_id => user_id, :do => 'assign'})
      end

      def delete_application(application_id, options = {})
        boolean_from_response :delete, "applications/#{application_id}", options
      end

    end
  end
end
