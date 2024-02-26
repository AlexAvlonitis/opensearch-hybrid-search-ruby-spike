module Feedback
  class SearchController < ApplicationController
    def index
      render json: Services::Feedback::Search.call(params[:q])
    end
  end
end
