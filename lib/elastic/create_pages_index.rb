require 'opensearch-ruby'

client = OpenSearch::Client.new(url: 'http://localhost:9200')

index_mapping = {
  settings: {
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
      url: { type: 'keyword' },
      html: { type: 'text' },
      text: { type: 'text', analyzer: 'stem_analyzer' },
      title: { type: 'text', analyzer: 'stem_analyzer' },
      description: { type: 'text', analyzer: 'stem_analyzer' },
      public_updated_at: { type: 'date' },
      created_at: { type: 'date' },
      updated_at: { type: 'date' },
      openai_hnsw: { type: 'dense_vector', dims: 1536 },
      openai_ivfflat: { type: 'dense_vector', dims: 1536 }
    }
  }
}

client.indices.create(index: 'pages_index', body: index_mapping)
