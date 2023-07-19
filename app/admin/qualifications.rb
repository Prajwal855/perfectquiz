require 'csv'
require 'roo'

ActiveAdmin.register Qualification do

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
    f.inputs "Qualification Details" do
      f.input :name
    end
    f.actions
  end

  member_action :download_csv, method: :get do
    qualification = Qualification.find(params[:id])
    send_data qualification.to_csv, filename: "qualification_#{ualification.id}.csv"
   end
  
   action_item :import_csv, only: :index do
    link_to 'Import CSV', new_import_csv_admin_qualifications_path
   end
  
   collection_action :new_import_csv, method: :get do
    @qualification = Qualification.new
    render 'admin/qualifications/import_csv_form'
   end
  
   collection_action :import_csv, method: :post do
    if params[:qualification] && params[:qualification][:csv_file]
     csv_file = params[:qualification][:csv_file]
     if csv_file.present?
      begin
       CSV.foreach(csv_file.path, headers: true) do |row|
        Qualification.create(name: row['name'])
       end
       redirect_to admin_qualifications_path, notice: 'CSV file imported successfully.'
      rescue StandardError => e
       redirect_to new_import_csv_admin_qualifications_path, alert: "Error importing CSV file: #{e.message}"
      end
     else
      redirect_to new_import_csv_admin_qualifications_path, alert: 'No CSV file was uploaded.'
     end
    else
     redirect_to new_import_csv_admin_qualifications_path, alert: 'No CSV file was uploaded.'
    end
   end
  
   action_item :import_excel, only: :index do
      link_to 'Import Excel', new_import_excel_admin_qualifications_path
     end
    
     collection_action :new_import_excel, method: :get do
      @qualification = Qualification.new
      render 'admin/qualifications/import_excel_form'
     end
  
     collection_action :import_excel, method: :post do
      if params[:qualification] && params[:qualification][:excel_file].present?
        file = params[:qualification][:excel_file].tempfile
        imported_count = 0
  
        begin
          excel = Roo::Spreadsheet.open(file)
          sheet = excel.sheet(0)
  
          sheet.each_row_streaming(offset: 1) do |row|
            name = row[0].value
            qualification = Qualification.create(name: name)
            imported_count += 1 if qualification.persisted?
          end
  
          redirect_to admin_qualifications_path, notice: "#{imported_count} records imported successfully from Excel."
        rescue StandardError => e
          redirect_to new_import_excel_admin_qualifications_path, alert: "Error importing Excel file: #{e.message}"
        end
      else
        redirect_to new_import_excel_admin_qualifications_path, alert: 'No Excel file was uploaded.'
      end
    end
  
end
