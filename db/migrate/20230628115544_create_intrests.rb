class CreateIntrests < ActiveRecord::Migration[7.0]
  def change
    create_table :intrests do |t|
      t.string :name

      t.timestamps
    end
  end
end
