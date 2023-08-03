class ChaptersController < BaseController
    before_action :logged_in_user, only: [:index, :show]
    before_action :check_admin_user, only: [:create, :destroy]

    def index
        chapters = Chapter.all
        if chapters.empty?
            render json: {
                message: "Chapters Not Found",
                chapters: []
            }, status: :not_found
        else
            response = chapters.map do |chapter|
                {
                    chap: chapter.chap,
                    course_id: chapter.course_id,
                    studymaterials: chapter.studymaterials.map do |studymaterial|
                    {
                        id: studymaterial.id,
                        video: studymaterial.video.present? ? url_for(studymaterial.video) : nil,
                        softcopy: studymaterial.softcopy.present? ? url_for(studymaterial.softcopy) : nil
                    }
                    end
                }
                end
        
                render json: {
                message: "Chapters Found",
                chapters: response
                }, status: :ok
        end
    end

    def show
        chapter = set_chapter
        if chapter
                render json: {
                message: "Chapters Found",
                chap: chapter.chap,
                studymaterials: chapter.studymaterials.map do |studymaterial|
                    {
                        id: studymaterial.id,
                        textbook: studymaterial.textbook,
                        video: studymaterial.video.present? ? url_for(studymaterial.video) : nil,
                        softcopy: studymaterial.softcopy.present? ? url_for(studymaterial.softcopy) : nil
                    }
                    end
                }, status: :ok
        else
            render json: {
                message: "Chapter Not Found",
                chapter: []
            }, status: :not_found
        end
    end

    def create
        chapter = Chapter.create(chapter_params)
        if chapter.save
            render json: {
                message: "Chapter Created Successfully",
                chapter: chapter.as_json(only: [:chap, :course_id])
            }, status: :created
        else
            render json: {
                message: "Chapter cannot be Created",
                error: chapter.errors.full_messages
            }, status: 422
        end
    end

    def destroy
        chapter = set_chapter
        if chapter.delete
            render json: {
                message: "Chapter Deleted Successfully",
                chapter: chapter.as_json(only: [:chap, :course_id])
            }, status: :ok
        else
            render json: {
                message: "Chapter Cannot Be Deleted",
                error: chapter.errors.full_messages
            }, status: 422
        end
    end


    private
    def set_chapter
        chapter = Chapter.find_by(id: params[:id])
        if chapter
            return chapter
        end
    end

    def check_admin_user
        if logged_in_user.admin? || logged_in_user.role == "admin" || logged_in_user.role == "teacher"
            return logged_in_user
        else
            render json: { message: "Dude You Don't have permission"
             }, status: 401
        end
    end

    def chapter_params
        params.require(:chapter).permit(:chap,:course_id)
    end
end
