ActiveAdmin.register Question do
  permit_params :que, :correct_answer, :level, :language, choices_attributes: [:id, :option, :_destroy]


  index do
    selectable_column
    id_column
    column :que
    column :correct_answer
    column :level
    column :language
    actions
  end

  form do |f|
    f.inputs "Question" do
      f.input :que
      f.input :correct_answer
      f.input :level, as: :select, collection: ['level1', 'level2', 'level3'], include_blank: false
      f.input :language, as: :select, collection: ['Ruby', 'ReactJS', 'ReactNative'], include_blank: false
    end

    f.inputs "Choices" do
      f.has_many :choices, allow_destroy: true, new_record: 'Add Option' do |o|
        o.input :option
      end
    end

    f.actions
  end

  controller do
    def create
      @question = Question.new(permitted_params[:question])
      if @question.save
        redirect_to admin_questions_path, notice: 'Question created successfully.'
      else
        render :new
      end
    end
  end
end
