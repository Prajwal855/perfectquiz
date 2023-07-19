require 'csv'
require 'roo'

ActiveAdmin.register Intrest do
 permit_params :name

 index do
    selectable_column
    id_column
    column :name
    actions
   end

 member_action :download_csv, method: :get do
  intrest = Intrest.find(params[:id])
  send_data intrest.to_csv, filename: "inerest_#{intrest.id}.csv"
 end

 action_item :import_csv, only: :index do
  link_to 'Import CSV', new_import_csv_admin_intrests_path
 end

 collection_action :new_import_csv, method: :get do
  @intrest = Intrest.new
  render 'admin/intrests/import_csv_form'
 end

 collection_action :import_csv, method: :post do
  if params[:intrest] && params[:intrest][:csv_file]
   csv_file = params[:intrest][:csv_file]
   if csv_file.present?
    begin
     CSV.foreach(csv_file.path, headers: true) do |row|
      Intrest.create(name: row['name'])
     end
     redirect_to admin_intrests_path, notice: 'CSV file imported successfully.'
    rescue StandardError => e
     redirect_to new_import_csv_admin_intrests_path, alert: "Error importing CSV file: #{e.message}"
    end
   else
    redirect_to new_import_csv_admin_intrests_path, alert: 'No CSV file was uploaded.'
   end
  else
   redirect_to new_import_csv_admin_intrests_path, alert: 'No CSV file was uploaded.'
  end
 end

 action_item :import_excel, only: :index do
    link_to 'Import Excel', new_import_excel_admin_intrests_path
   end
  
   collection_action :new_import_excel, method: :get do
    @intrest = Intrest.new
    render 'admin/intrests/import_excel_form'
   end

   collection_action :import_excel, method: :post do
    if params[:intrest] && params[:intrest][:excel_file].present?
      file = params[:intrest][:excel_file].tempfile
      imported_count = 0

      begin
        excel = Roo::Spreadsheet.open(file)
        sheet = excel.sheet(0)

        sheet.each_row_streaming(offset: 1) do |row|
          name = row[0].value
          intrest = Intrest.create(name: name)
          imported_count += 1 if intrest.persisted?
        end

        redirect_to admin_intrests_path, notice: "#{imported_count} records imported successfully from Excel."
      rescue StandardError => e
        redirect_to new_import_excel_admin_intrests_path, alert: "Error importing Excel file: #{e.message}"
      end
    else
      redirect_to new_import_excel_admin_intrests_path, alert: 'No Excel file was uploaded.'
    end
  end
end
