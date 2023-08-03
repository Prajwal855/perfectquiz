class ClearExpiredTokensJob < ApplicationJob
    queue_as :default
  
    def perform
      User.where('token_expiration_time < ?', Time.now).update_all(token: nil)
    end
  end