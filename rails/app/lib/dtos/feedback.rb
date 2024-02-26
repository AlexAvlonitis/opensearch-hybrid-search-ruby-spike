module Dtos
  module Feedback
    Request = Data.define(
      :response_value,
      :record_id,
      :response_identifier,
      :public_created_at,
      :subject_page_path,
      :vector
    )
    Response = Data.define(
      :response_value,
      :record_id,
      :public_created_at,
      :subject_page_path
    )
  end
end
