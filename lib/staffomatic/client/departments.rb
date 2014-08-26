module Staffomatic
  class Client

    # Methods for the Departments API
    #
    # @see https://developer.github.com/v3/departments/
    module Departments

      # List all Staffomatic departments
      #
      # This provides a dump of every departments, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/departments/#get-all-departments
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic departments.
      def all_departments(options = {})
        paginate "departments", options
      end

      # List all Staffomatic location departments
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/departments/#get-location-special-days
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic departments.
      def location_departments(location_id, options = {})
        paginate "locations/#{location_id}/departments", options
      end

      # Get a single department
      #
      # @param department_id [Integer] Staffomatic department id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/departments/#get-a-single-department
      # @example
      #   Staffomatic.user(493)
      def department(department_id, options = {})
        get "departments/#{department_id}", options
      end

      # Update a department
      #
      # @param department_id [Integer] Staffomatic department id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-departments
      # @example
      #   Staffomatic.update_departments(:name => "Erik Michaels-Ober")
      def update_department(department_id, options)
        patch "departments/#{department_id}", :department => options
      end

      # Create a department
      #
      # @param name [String] The name of your department
      # @return [Sawyer::Resource] Your newly created departments
      # @see https://developer.github.com/v3/departments/#create-an-departments
      # @example Create a new Location
      #   Octokit.create_departments()
      def create_department(location_id, options)
        post "locations/#{location_id}/departments", :department => options
      end

      # Delete a single department
      #
      # @param department_id [Integer] A Staffomatic department
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/departments/#delete-a-department
      # @example Delete the department #1194549
      #   Staffomatic.delete_department(1194549)
      def delete_department(department_id, options = {})
        boolean_from_response :delete, "departments/#{department_id}", options
      end

    end
  end
end
