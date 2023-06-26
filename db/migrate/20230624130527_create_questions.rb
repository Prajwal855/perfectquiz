class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :que
      t.string :correct_answer
      t.string :level
      t.string :language

      t.timestamps
    end
  end
end
