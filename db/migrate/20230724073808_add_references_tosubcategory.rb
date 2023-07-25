class AddReferencesTosubcategory < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :category, foreign_key: true
    add_reference :courses, :subcategory, foreign_key: true
  end
end
