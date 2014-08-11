require 'staffomatic/response/raise_error'
require 'staffomatic/response/feed_parser'
require 'staffomatic/version'

module Staffomatic

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    API_ENDPOINT = "https://staffomatic.com".freeze

    # Default User Agent header string
    USER_AGENT   = "Staffomatic Ruby Gem #{Staffomatic::VERSION}".freeze

    # Default media type
    MEDIA_TYPE   = "application/vnd.staffomatic.v3+json"

    # Default API version
    API_VERSION   = "/v3"

    # Default WEB endpoint
    WEB_ENDPOINT = "https://staffomatic.com".freeze

    # In Faraday 0.9, Faraday::Builder was renamed to Faraday::RackBuilder
    RACK_BUILDER_CLASS = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder

    # Default Faraday middleware stack
    MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
      builder.use Staffomatic::Response::RaiseError
      builder.use Staffomatic::Response::FeedParser
      builder.adapter Faraday.default_adapter
    end

    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[Staffomatic::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default access token from ENV
      # @return [String]
      def access_token
        ENV['STAFFOMATIC_ACCESS_TOKEN']
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['STAFFOMATIC_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default pagination preference from ENV
      # @return [String]
      def auto_paginate
        ENV['STAFFOMATIC_AUTO_PAGINATE']
      end

      # Default OAuth app key from ENV
      # @return [String]
      def client_id
        ENV['STAFFOMATIC_CLIENT_ID']
      end

      # Default OAuth app secret from ENV
      # @return [String]
      def client_secret
        ENV['STAFFOMATIC_SECRET']
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :accept => default_media_type,
            :user_agent => user_agent
          }
        }
      end

      # Default media type from ENV or {MEDIA_TYPE}
      # @return [String]
      def default_media_type
        ENV['STAFFOMATIC_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      # Default API version from ENV or {API_VERSION}
      # @return [String]
      def default_api_version
        ENV['STAFFOMATIC_DEFAULT_API_VERSION'] || API_VERSION
      end

      # Default Staffomatic email for Basic Auth from ENV
      # @return [String]
      def email
        ENV['STAFFOMATIC_EMAIL']
      end

      # Default middleware stack for Faraday::Connection
      # from {MIDDLEWARE}
      # @return [String]
      def middleware
        MIDDLEWARE
      end

      # Default Staffomatic password for Basic Auth from ENV
      # @return [String]
      def password
        ENV['STAFFOMATIC_PASSWORD']
      end

      # Default pagination page size from ENV
      # @return [Fixnum] Page size
      def per_page
        page_size = ENV['STAFFOMATIC_PER_PAGE']

        page_size.to_i if page_size
      end

      # Default proxy server URI for Faraday connection from ENV
      # @return [String]
      def proxy
        ENV['STAFFOMATIC_PROXY']
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['STAFFOMATIC_USER_AGENT'] || USER_AGENT
      end

      # Default web endpoint from ENV or {WEB_ENDPOINT}
      # @return [String]
      def web_endpoint
        ENV['STAFFOMATIC_WEB_ENDPOINT'] || WEB_ENDPOINT
      end

    end
  end
end
