ActiveAdmin.register Chapter do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # form do|f|
  #   f.input :chap
  #   f.input :course_id, as: :select, collection: Course.pluck(:modul)
  # end
  permit_params :course_id, :chap
  #
  # or
  #
  # permit_params do
  #   permitted = [:chap, :course_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs "Chapters Detail" do
      f.input :chap
      f.input :course_id, as: :select, collection: Course.pluck(:modul, :id)
    end
    f.actions
  end




  index do
    selectable_column
    id_column
    column :chap
    actions
   end
end
