class Adduserotpverifiedfeild < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp_verified, :boolean
  end
end
