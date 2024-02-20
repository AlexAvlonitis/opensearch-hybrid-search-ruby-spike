require "openai"

module Llms
  module Openai
    class Client
      def initialize(client = ::OpenAI::Client.new(access_token: ENV["OPEN_AI_ACCESS_TOKEN"]))
        @client = client
      end

      def embedding(text)
        client.embeddings(parameters: parameters(text)).dig("data", 0, "embedding")
      end

    private

      attr_reader :client

      def parameters(text)
        {
          model: ENV.fetch("EMBEDDING_MODEL"),
          input: text,
          dimensions: 256,
        }
      end
    end
  end
end
