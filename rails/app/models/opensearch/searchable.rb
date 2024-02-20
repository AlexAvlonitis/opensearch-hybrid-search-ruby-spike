module Opensearch
  # This will be instantiated once, kinda like a singleton.
  def self.client
    @client ||= OpenSearch::Client.new(url: ENV['OPENSEARCH_URL'], log: true)
  end

  module Searchable
    # This will be instantiated once in the model that includes this module
    def config
      @config ||= { settings: {}, mappings: {} }
    end

    def index_mappings
      result = yield
      config[:mappings] = result
    end

    def index_settings
      result = yield
      config[:settings] = result
    end

    # Delete and recreate the index, the index name is the model name in lowercase
    def recreate_index(index_name = name.downcase)
      delete_index(index_name) if index_exists?(index_name)
      create_index(index_name)
    end

    def create_index(index_name = name.downcase)
      _client.indices.create(index: index_name)
    end

    def delete_index(index_name = name.downcase)
      _client.indices.delete(index: index_name)
    end

    def index_exists?(index_name)
      _client.indices.exists?(index: index_name)
    end

    def index_data(data, index_name = name.downcase, refresh: false)
      _client.index(index: index_name, body: data, refresh:)
    end

    def query(query, index_name = name.downcase)
      _client.search(index: index_name, body: query)
    end

    # To indicate that this method is private, but still be able to access it if
    # we needed to.
    def _client
      Opensearch.client
    end
  end
end
