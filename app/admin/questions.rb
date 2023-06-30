ActiveAdmin.register Question do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :que, :correct_answer, :level, :language
  #
  # or
  #
  # permit_params do
  #   permitted = [:que, :correct_answer, :level, :language]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :que, :correct_answer, :level, :language

  form do|f|
    f.input :que
    f.input :correct_answer
    f.input :level
    f.input :language
    f.actions
  end
  
end
