module Staffomatic
  class Client

    # Methods for the NewsItems API
    #
    # @see https://developer.github.com/v3/news_items/
    module NewsItems

      # List all Staffomatic news_items
      #
      # This provides a dump of every news_items, in the order that they signed up
      # for Staffomatic.
      #
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/news_items/#get-all-news_items
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic news_items.
      def all_news_items(options = {})
        paginate "news_items", options
      end

      # List all Staffomatic location news_items
      #
      # @param location_id [Integer] Location id.
      # @param options [Hash] Optional options.
      #
      # @see https://developer.github.com/v3/news_items/#get-location-special-days
      #
      # @return [Array<Sawyer::Resource>] List of Staffomatic news_items.
      def location_news_items(location_id, options = {})
        paginate "locations/#{location_id}/news_items", options
      end

      # Get a single news_item
      #
      # @param news_item_id [Integer] Staffomatic news_item id.
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/news_items/#get-a-single-news_item
      # @example
      #   Staffomatic.user(493)
      def news_item(news_item_id, options = {})
        get "news_items/#{news_item_id}", options
      end

      # Update a news_item
      #
      # @param news_item_id [Integer] Staffomatic news_item id.
      # @option options [String] :name
      # @return [Sawyer::Resource]
      # @see https://developer.github.com/v3/users/#update-the-authenticated-news_items
      # @example
      #   Staffomatic.update_news_items(:name => "Erik Michaels-Ober")
      def update_news_item(news_item_id, options)
        patch "news_items/#{news_item_id}", :news_item => options
      end

      # Create a news_item
      #
      # @param name [String] The name of your news_item
      # @return [Sawyer::Resource] Your newly created news_items
      # @see https://developer.github.com/v3/news_items/#create-an-news_items
      # @example Create a new Location
      #   Octokit.create_news_items()
      def create_news_item(location_id, options)
        post "locations/#{location_id}/news_items", :news_item => options
      end

      # Delete a single news_item
      #
      # @param news_item_id [Integer] A Staffomatic news_item
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/news_items/#delete-a-news_item
      # @example Delete the news_item #1194549
      #   Staffomatic.delete_news_item(1194549)
      def delete_news_item(news_item_id, options = {})
        boolean_from_response :delete, "news_items/#{news_item_id}", options
      end

    end
  end
end
