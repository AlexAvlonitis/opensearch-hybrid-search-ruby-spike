require 'opensearch-ruby'
require 'yaml'

client = OpenSearch::Client.new(
  host: 'http://opensearch:9200',
  user: 'admin',
  password: 'admin',
  log: true
)

index_mapping = {
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
}

client.indices.delete(index: 'feedback_index') if client.indices.exists?(index: 'feedback_index')
client.indices.create(index: 'feedback_index', body: index_mapping)

puts "Feedback index created"

# Load the data ========================================

puts "Loading feedback data..."

def data_mapping(row)
  row['vector'] = JSON.parse(row['vector'])
  row
end

records_path = File.join(File.expand_path(Dir.pwd), '/lib/data', '5_feedback_records.yml')
records = YAML.load_file(records_path, permitted_classes: [Time])
records.each do |row|
  client.index(index: 'feedback_index', body: data_mapping(row), refresh: true)
end

