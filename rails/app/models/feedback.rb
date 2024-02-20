class Feedback
  extend Opensearch::Searchable

  index_settings do
    {
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
    }
  end

  index_mappings do
    {
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
  end
end
