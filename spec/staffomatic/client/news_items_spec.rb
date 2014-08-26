require 'helper'

describe Staffomatic::Client::NewsItems do

  before(:each) do
    Staffomatic.reset!
    @client = oauth_client
  end

  describe ".all_news_items", :vcr do

    it "returns all Staffomatic news_items" do
      news_items = @client.all_news_items
      expect(news_items).to be_kind_of Array
    end

    it "returns all Staffomatic news_items for a location" do
      news_items = @client.location_news_items(64)
      expect(news_items).to be_kind_of Array
    end

  end # .all_news_items

  describe ".news_item", :vcr do
    it "returns a news_item" do
      news_item = @client.news_item(4934)
      expect(news_item.title).to match(/Assumenda ex ea incidunt/)
    end
  end # .news_item

  describe ".update_news_items", :vcr do
    it "updates a news_item" do
      news_items = @client.update_news_item(4934, :user_ids => [493])
      expect(news_items.user_ids).to eq([493])
      assert_requested :patch, staffomatic_url("/news_items/4934")
    end
  end # .update_news_items

  describe ".create_news_item", :vcr do
    it "creates a news_item" do
      news_item = @client.create_news_item(64, { :title => "A cool news item title",
                                                 :body => "should also have some cool text!",
                                                 :user_ids => [493],
                                                 :commentable => true,
                                                 :attachable => true } )
      expect(news_item.title).to match(/A cool news item title/)
      assert_requested :post, staffomatic_url("locations/64/news_items")
    end
  end # .create_news_item

  describe ".delete_news_item" do
    xit "deletes an existing news_item" do
      @client.delete_news_item(12302)
      assert_requested :delete, staffomatic_url("/news_items/12302")
    end
  end # .delete_news_item

end
