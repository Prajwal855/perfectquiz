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

  index do
    selectable_column
    id_column
    column :que
    column :correct_answer
    column :level
    column :language
    actions
   end

  form do|f|
    f.inputs "Question" do
      f.input :que
      f.input :correct_answer
      f.input :level
      f.input :language
    end
    f.actions
  end
  
end
