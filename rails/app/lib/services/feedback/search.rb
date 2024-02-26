module Services
  module Feedback
    class Search
      private_class_method :new

      def self.call(query, **args)
        repo = args.fetch(:repo, Repositories::Feedback.new)
        new(query, repo).call
      end

      def initialize(query, repo)
        @query = query
        @repo = repo
      end

      def call
        repo.search(opensearch_query)
      end

      private

      attr_reader :query, :repo

      # this could be extracted to a separate class
      def opensearch_query
        {
          query: {
            multi_match: {
              query:,
              fields: [:response_value]
            }
          },
          _source: [
            :record_id,
            :response_value,
            :public_created_at,
            :subject_page_path
          ]
        }
      end
    end
  end
end
