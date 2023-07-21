class ClearExpiredTokensJob < ApplicationJob
    queue_as :default
  
    def perform
      User.where('token_expiration_time < ?', Time.now).delete_all
    end
  end