ActiveAdmin.register Course do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :modul

  index do
    selectable_column
    id_column
    column :modul
    actions
   end
  #
  # or
  #
  # permit_params do
  #   permitted = [:modul]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do|f|
    f.inputs "Course Details" do
      f.input :modul
    end
   f.actions
  end
  
end
