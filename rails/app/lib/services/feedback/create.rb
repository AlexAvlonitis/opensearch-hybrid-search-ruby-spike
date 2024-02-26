module Services
  module Feedback
    class Create
      private_class_method :new

      def self.call(attributes, **args)
        repo = args.fetch(:repo, Repositories::Feedback.new)
        new(attributes, repo).call
      end

      def initialize(attributes, repo)
        @attributes = attributes
        @repo = repo
      end

      def call
        repo.create(feedback, refresh: true)
      end

      private

      attr_reader :attributes, :repo

      def feedback
        @feedback ||= Dtos::Feedback::Request.new(**attributes)
      end
    end
  end
end
