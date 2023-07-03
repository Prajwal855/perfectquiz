class StudymaterialSerializer
  include FastJsonapi::ObjectSerializer
  attributes :textbook,:chapter_id

  attribute :softcopy do |softcopychapter|
    if softcopychapter.softcopy.present?
      host = Rails.env.development? ? 'http://localhost:3000' : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(softcopychapter.softcopy,only_path: true)
    end
  end

  attribute :video do |chaptervideo|
    if chaptervideo.video.present?
      host = Rails.env.development? ? 'http://localhost:3000' : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(chaptervideo.video,only_path: true)
    end
  end
end
