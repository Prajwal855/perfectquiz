class CategoriesController < BaseController
    before_action :logged_in_user
    def index 
       categories =Category.all
        if categories.empty?
            render json: {
                message:    "Categories Not Found",
               Categorys: []
            }, status: :not_found
        else
            render json: {
                message:    "Categories Found",
                categorys: categories.as_json(only: [:id, :name], include: { subcategories: { only: [:id,:name] } })
            }, status: :ok
        end
    end

    def show
        category = set_category
        if category
            render json: {
                message: "Category Found",
                category: category.as_json(only: [:id, :name])
            }, status: :ok
        else
            render json: {
                message: "Category Not Found",
                category: []
            }, status: :not_found
        end
    end

    def create
        if logged_in_user.admin? || logged_in_user.role == "admin"
           category = Category.create(category_params)
            if category.save
                render json: {
                    message: "Category Created successfully",
                   category: category.as_json(only: [:id, :name])
                }, status: :created
            else
                render json: {
                    message: "Category Unable to Create",
                    error:category.errors.full_messages
                }, status: 422
            end
        else
            render json: { message: "Dude You Don't have permission"
                }, status: 401
        end
    end

    def destroy
        if logged_in_user.admin? || logged_in_user.role == "admin"
           category = set_category
            if category.delete
                render json: {
                    message: "Category Deleted Successfully",
                   category: category.as_json(only: [:id, :name])
                }, status: :ok
            else
                render json: {
                    message: "Category unable to Delete",
                    error:category.errors.full_messages
                }, status: 422
            end
        else
            render json: { message: "Dude You Don't have permission"
                }, status: 401
        end
    end

    private
    def category_params
        params.require(:category).permit(:name)
    end

    def set_category
       category = Category.find_by(id: params[:id])
        if category
            return category
        end
    end
end
