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

  action_item :import_excel, only: :index do
    link_to 'Import Excel', new_import_excel_admin_questions_path
   end
  
   collection_action :new_import_excel, method: :get do
    @question = Question.new
    render 'admin/questions/import_excel_form'
   end

  action_item :import_csv, only: :index do
      link_to 'Import CSV', new_import_csv_admin_questions_path
     end
     
  collection_action :new_import_csv, method: :get do
    @question = Question.new
    render 'admin/questions/import_csv_form'
    end

    collection_action :import_csv, method: :post do
      if params[:question] && params[:question][:csv_file]
       csv_file = params[:question][:csv_file]
       if csv_file.present?
        begin
         CSV.foreach(csv_file.path, headers: true) do |row|
          question_params = row.to_h.slice('que','correct_answer', 'level', 'language')
          options_param = row['options']
          
          question = Question.new(question_params)

          options = options_param.split(',') 
     
          options.each do |option_text|
           question.choices.build(option: option_text)
          end
     
          question.save
         end
         redirect_to admin_questions_path, notice: 'CSV file imported successfully.'
        rescue StandardError => e
         redirect_to new_import_csv_admin_questions_path, alert: "Error importing CSV file: #{e.message}"
        end
       else
        redirect_to new_import_csv_admin_question_path, alert: 'No CSV file was uploaded.'
       end
      else
       redirect_to new_import_csv_admin_questions_path, alert: 'No CSV file was uploaded.'
      end
     end

collection_action :import_excel, method: :post do
  if params[:question] && params[:question][:excel_file]
    excel_file = params[:question][:excel_file]
    if excel_file.present?
      begin
        spreadsheet = Roo::Spreadsheet.open(excel_file.path)
        sheet = spreadsheet.sheet(0)

        sheet.each_row_streaming(offset: 1) do |row|
          question_params = {
            'que' => row[0].value,
            'correct_answer' => row[1].value,
            'level' => row[2].value,
            'language' => row[3].value
          }
          options_param = row[4].value

          question = Question.new(question_params)

          options = options_param.split(',')

          options.each do |option_text|
            question.choices.build(option: option_text.strip)
          end

          question.save
        end

        redirect_to admin_questions_path, notice: 'Excel file imported successfully.'
      rescue StandardError => e
        redirect_to new_import_excel_admin_questions_path, alert: "Error importing Excel file: #{e.message}"
      end
    else
      redirect_to new_import_excel_admin_question_path, alert: 'No Excel file was uploaded.'
    end
  else
    redirect_to new_import_excel_admin_questions_path, alert: 'No Excel file was uploaded.'
  end
end

end
