class FeedbackController < ApplicationController
  def index
    render json: Feedback.query(query)
  end

  private

  # If we wanted additional abstraction. This query could also be created via
  # a query builder or something similar.
  # E.g QueryBuilder.new(***).build
  def query
    {
      query: {
        multi_match: {
          query: params[:q],
          fields: [:response_value]
        }
      },
      _source: [
        :record_id,
        :response_value,
      ]
    }
  end
end
