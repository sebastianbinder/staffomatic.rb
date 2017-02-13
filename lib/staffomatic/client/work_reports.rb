module Staffomatic
  class Client

    # Methods for the SpecialDays API
    #
    # @see https://developer.github.com/v3/work_reports/
    module WorkReports

      # List all Staffomatic work_reports
      #
      # This provides a dump of every work_reports, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/work_reports/#get-all-work_reports
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic work_reports.
      def all_work_reports(options = {})
        paginate "work_reports", options
      end

      # List all Staffomatic location work_reports
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/work_reports/#get-location-special-days
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic work_reports.
      def location_work_reports(location_id, options = {})
        paginate "locations/#{location_id}/work_reports", options
      end

      # Get a single work_report
      #
      # @param work_report_id [Integer] Staffomatic work_report id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/work_reports/#get-a-single-work_report
      # @example
      #   Staffomatic.user(493)
      def work_report(work_report_id, options = {})
        get "work_reports/#{work_report_id}", options
      end

    end
  end
end
