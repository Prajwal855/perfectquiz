class AddTokenExpirationTimeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :token_expiration_time, :datetime
  end
end
