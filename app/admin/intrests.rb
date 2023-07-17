ActiveAdmin.register Intrest do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name

  index do
      selectable_column
      id_column
      column :name
      actions
     end
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do|f|
    f.inputs "Intrest Details" do
      f.input :name
    end
    f.actions
  end
  
end
