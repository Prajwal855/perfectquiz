class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.string :chap
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
