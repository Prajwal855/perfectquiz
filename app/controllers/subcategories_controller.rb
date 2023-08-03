class SubcategoriesController < BaseController
    before_action :logged_in_user, only: [:index, :show]
    before_action :check_admin_user, only: [:create, :destroy]
    def index 
       subcategories = Subcategory.all
        if subcategories.empty?
            render json: {
                message:    "SubCategories Not Found",
               subcategories: []
            }, status: :not_found
        else
            render json: {
                message:    "SubCategories Found",
                subcategories: subcategories.as_json(only: [:id, :name])
            }, status: :ok
        end
    end

    def show
        subcategory = set_subcategory
        if subcategory
            render json: {
                message: "Subcategory Found",
                subcategory: subcategory.as_json(only: [:id, :name])
            }, status: :ok
        else
            render json: {
                message: "Subcategory Not Found",
                subcategory: []
            }, status: :not_found
        end
    end

    def create
        subcategory = Subcategory.create(subcategory_params)
        if category.save
            render json: {
                message: "Subcategory Created successfully",
                subcategory: subcategory.as_json(only: [:id, :name])
            }, status: :created
        else
            render json: {
                message: "Subcategory Unable to Create",
                error:subcategory.errors.full_messages
            }, status: 422
        end
    end

    def destroy
        subcategory = set_subcategory
        if subcategory.delete
            render json: {
                message: "Subcategory Deleted Successfully",
                subcategory: subcategory.as_json(only: [:id, :name])
            }, status: :ok
        else
            render json: {
                message: "Subcategory unable to Delete",
                error:subcategory.errors.full_messages
            }, status: 422
        end
    end

    private
    def subcategory_params
        params.require(:subcategory).permit(:name,:category_id)
    end

    def check_admin_user
        if logged_in_user.admin? || logged_in_user.role == "admin"
            return logged_in_user
        else
            render json: { message: "Dude You Don't have permission"
             }, status: 401
        end
    end

    def set_subcategory
       subcategory = Subcategory.find_by(id: params[:id])
        if subcategory
            return subcategory
        end
    end
end
