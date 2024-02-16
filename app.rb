require 'sinatra'
require 'opensearch-ruby'
require 'lib/openai'

opensearch_client = OpenSearch::Client.new(url: 'http://localhost:9200')
openai_client = Llms::Openai::Client.new

get '/search' do
  query = params[:q]

  keyword_search = opensearch_client.search(index: 'pages_index', body: {
    query: {
      multi_match: {
        query: query,
        fields: ['title', 'description']
      }
    }
  })

  query_embedding = openaiclient.embedding(query)
  vector_search = opensearch_client.search(index: 'pages_index', body: {
    query: {
      "knn": {
        "openai_hnsw": {
          "vector": { "values": query_embedding },
          "k": 10
        }
      }
    }
  })

  keyword_hits = keyword_search['hits']['hits'].map { |hit| hit['_source'] }
  vector_hits = vector_search['hits']['hits'].map { |hit| hit['_source'] }

  combined_hits = (keyword_hits + vector_hits).uniq(&:id)
  combined_hits.to_json
end
