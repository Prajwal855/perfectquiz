ActiveAdmin.register Studymaterial do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :textbook, :chapter_id, as: :select, collection: Chapter.pluck(:id)
  #
  # or
  #
  # permit_params do
  #   permitted = [:textbook, :chapter_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do|f|
    f.input :chapter_id, as: :select, collection: Chapter.pluck(:id)
    f.input :video, as: :file
    f.input :softcopy, as: :file
    f.input :textbook
    f.actions
  end
  
end
