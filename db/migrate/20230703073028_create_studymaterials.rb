class CreateStudymaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :studymaterials do |t|
      t.text :textbook
      t.references :chapter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
