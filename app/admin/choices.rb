ActiveAdmin.register Choice do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :option, :question_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:option, :question_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :option, :question_id

  # form do|f|
  #   f.input :option
  #   f.input :question_id
  #   f.actions
  # end
end
