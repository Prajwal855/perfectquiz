require 'csv'
require 'roo'

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
  
  
  collection_action :import_csv, method: :post do
    if params[:intrest] && params[:intrest][:csv_file].present? && params[:intrest][:csv_file].respond_to?(:tempfile)
      file = params[:interest][:csv_file].tempfile
      imported_count = 0
      CSV.foreach(file, headers: true) do |row|
        interest = Intrest.new(name: row['name'])
        if interest.save
          imported_count += 1
        else
        end
      end

      flash[:notice] = "#{imported_count} records imported successfully!"
      redirect_to admin_intrests_path
    else
      flash[:alert] = 'Please select a CSV file to import.'
      render :index
    end
  end

  action_item :import_csv, only: :index do
    link_to 'Import CSV', action: :import_csv
  end

  collection_action :import_excel, method: :post do
    file = params[:excel_file].tempfile
    excel = Roo::Spreadsheet.open(file)
    sheet = excel.sheet(0)
    sheet.each_row_streaming(offset: 1) do |row|
      Intrest.create!(name: row[0].value)
    end
    redirect_to admin_intrests_path, notice: 'Excel imported successfully!'
  end

  action_item :import_excel, only: :index do
    link_to 'Import Excel', action: :import_excel
  end

  collection_action :import_csv, method: :get do
    render 'admin/intrests/import_csv'
  end

  collection_action :import_excel, method: :get do
    render 'admin/intrests/import_excel'
  end
end

