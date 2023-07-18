require 'csv'
require 'roo'

ActiveAdmin.register Intrest do
 permit_params :name, :csv_file

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
end
