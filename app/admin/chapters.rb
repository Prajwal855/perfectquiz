ActiveAdmin.register Chapter do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :chap, :course_id, as: :select, collection: Course.pluck(:id)
  #
  # or
  #
  # permit_params do
  #   permitted = [:chap, :course_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  form do|f|
    f.input :chap
    f.input :course_id, as: :select, collection: Course.pluck(:id)
    f.actions
  end
end
