class Page
  extend Opensearch::Searchable

  index_settings do
    {
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
      }
    }
  end
end
