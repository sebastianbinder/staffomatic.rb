require 'helper'

describe Staffomatic do
  before do
    Staffomatic.reset!
  end

  after do
    Staffomatic.reset!
  end

  it "sets defaults" do
    Staffomatic::Configurable.keys.each do |key|
      expect(Staffomatic.instance_variable_get(:"@#{key}")).to eq(Staffomatic::Default.send(key))
    end
  end

  describe ".client" do
    it "creates an Staffomatic::Client" do
      expect(Staffomatic.client).to be_kind_of Staffomatic::Client
    end
    it "caches the client when the same options are passed" do
      expect(Staffomatic.client).to eq(Staffomatic.client)
    end
    it "returns a fresh client when options are not the same" do
      client = Staffomatic.client
      Staffomatic.access_token = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = Staffomatic.client
      client_three = Staffomatic.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    Staffomatic::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Staffomatic.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Staffomatic.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

end
