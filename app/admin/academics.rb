ActiveAdmin.register Academic do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :college_name, :interest_id, :qualification_id, :career_goals, :language, :other_language, :currently_working, :specialization, :experiance, :availability, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:college_name, :interest_id, :qualification_id, :career_goals, :language, :other_language, :currently_working, :specialization, :experiance, :availability, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :college_name, :intrest_id, :qualification_id,
  :career_goals, :language, :other_language, :specialization, :currently_working,
  :availability,:experiance, :user_id, :cv, :governament_id


  index do
    selectable_column
    id_column
    column :name
    actions
   end

  form do|f|
    f.inputs "Acadmics Details" do
      f.input :college_name
      f.input :intrest_id
      f.input :qualification_id
      f.input :career_goals
      f.input :language
      f.input :other_language
      f.input :specialization
      f.input :currently_working
      f.input :availability
      f.input :experiance
      f.input :user_id
      f.input :cv, as: :file
      f.input :governament_id, as: :file
    end
    f.actions
  end 
end
