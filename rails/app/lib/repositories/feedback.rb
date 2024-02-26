module Repositories
  class Feedback
    INDEX_NAME = 'feedback'.freeze

    def initialize(client = OpenSearch::Client.new(url: ENV.fetch('OPENSEARCH_URL')))
      @client = client
    end

    def search(query)
      response = client.search(index: INDEX_NAME, body: query)
      to_collection(response)
    end

    def create(feedback, refresh: false)
      client.index(index: INDEX_NAME, body: feedback.to_h, refresh:)
    end

    def create_index(force: false)
      delete_index if index_exists? && force
      client.indices.create(index: INDEX_NAME, body: INDEX_CONFIG)
    end

    def delete_index
      client.indices.delete(index: INDEX_NAME)
    end

    def index_exists?
      client.indices.exists?(index: INDEX_NAME)
    end

    private

    attr_reader :client

    def to_collection(response)
      response.dig('hits', 'hits').map { |hit| feedback(hit['_source']) }
    end

    def feedback(data_attrs)
      Dtos::Feedback::Response.new(**data_attrs)
    end

    # this could be extracted.
    INDEX_CONFIG = {
      settings: {
        knn: true,
        "knn.algo_param.ef_search": 100,
        analysis: {
          analyzer: {
            stem_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: ['lowercase', 'stemmer']
            }
          }
        }
      },
      mappings: {
        properties: {
          record_id: { type: 'keyword' },
          response_value: { type: 'text', analyzer: 'stem_analyzer' },
          vector: {
            type: "knn_vector",
            dimension: 256,
            method: {
              name: "hnsw",
              space_type: "cosinesimil",
              engine: "nmslib",
              parameters: {
                ef_construction: 128,
                m: 24
              }
            }
          }
        }
      }
    }.freeze
  end
end
