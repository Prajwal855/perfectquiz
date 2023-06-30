class DocumentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :college_name, :intrest_id, :qualification_id,
  :career_goals, :language, :other_language, :specialization,:currently_working,
  :availability,:experiance, :user_id

  attribute :cv do |resume|
    if resume.cv.present?
      host = Rails.env.development? ? 'http://localhost:3000' : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(resume.cv,only_path: true)
    end
  end

  attribute :governament_id do |governament_doc|
    if governament_doc.governament_id.present?
      host = Rails.env.development? ? 'http://localhost:3000' : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(governament_doc.governament_id,only_path: true)
    end
  end
end
