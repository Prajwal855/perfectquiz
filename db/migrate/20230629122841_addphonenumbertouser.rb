class Addphonenumbertouser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phonenumber, :string
  end
end
