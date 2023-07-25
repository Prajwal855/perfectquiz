ActiveAdmin.register Course do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :modul, :category_id, :subcategory_id

  form do |f|
    f.inputs "Course" do
      f.input :modul
      f.input :category, collection: Category.pluck(:name, :id)
      category_id = f.object.category_id
      subcategory_collection = Subcategory.where(category_id: category_id).pluck(:name, :id)
      f.input :subcategory_id, as: :select, collection: subcategory_collection, include_blank: false, input_html: { disabled: category_id.blank? }, id: 'subcategory-select'
    end
    f.actions
  end

  controller do
    def subcategory_options(category_id)
      return [] if category_id.blank?

      Subcategory.where(category_id: category_id).pluck(:name, :id)
    end
  end
  
end
