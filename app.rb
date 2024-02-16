require "dotenv"
require 'sinatra'
require 'opensearch-ruby'
require_relative './lib/llms/openai/client'
set :bind, '0.0.0.0'

Dotenv.load

opensearch_client = OpenSearch::Client.new(
    host: 'http://opensearch:9200',
    user: 'admin',
    password: 'admin',
    log: true
  )
openai_client = Llms::Openai::Client.new

get '/ping' do
  'pong'
end

get '/search' do
  query = params[:q]

  keyword_search = opensearch_client.search(index: 'feedback_index', body: {
    query: {
      multi_match: {
        query: query,
        fields: [:response_value]
      }
    },
    _source: [
      :record_id,
      :response_value,
    ]
  })

  query_embedding = openai_client.embedding(query)
  structured_query = {
    size: 2,
    query: {
      knn: {
        vector: {
          vector: query_embedding,
          k: 2
        }
      },
    },
    _source: [
      :record_id,
      :response_value,
    ]
  }
  vector_search = opensearch_client.search(index: 'feedback_index', body: structured_query)

  keyword_hits = keyword_search['hits']['hits'].map { |hit| hit['_source'] }
  vector_hits = vector_search['hits']['hits'].map { |hit| hit['_source'] }

  combined_hits = (keyword_hits + vector_hits).uniq
  combined_hits.to_json
end
