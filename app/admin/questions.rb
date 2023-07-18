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
  permit_params :que, :correct_answer, :level, :language, :option

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
      f.input :level, as: :select, collection: ['level1','level2','level3'], include_blank: false
      f.input :language, as: :select, collection: ['Ruby','ReactJS','ReactNative'], include_blank: false
    end
     f.inputs "choices" do
      f.has_many :choices, allow_destroy: true, new_record: 'Add Option' do |o|
       o.input :option
      end
     end
     f.actions
    end
   
    before_create do |question|
     if question.level.present? && !['level_1', 'level_2', 'level_3'].include?(question.level)
      question.errors.add(:level, "can only be level_1, level_2, or level_3")
      throw :abort
     end
    end
end

  
