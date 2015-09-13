class RecipesController < ApplicationController
    before_action :set_recipe, only: [:edit, :update, :show, :like]
    before_action :require_user, except: [:show, :index, :like]
    before_action :require_user_like, only: [:like]
    before_action :require_same_user, only: [:edit, :update]
    before_action :admin_user, only: :destroy
    
    def index
        @recipes = Recipe.paginate(page: params[:page], per_page: 4)
    end
    
    def show 
        #@recipe = Recipe.find(params[:id])
    end
    
    def new
        @recipe = Recipe.new
    end
    
    def create
        @recipe = Recipe.new(recipe_params)
        @recipe.chef = current_user
        
        if @recipe.save
            flash[:success] = "Your recipe was created successfully."
            redirect_to recipes_path
        else
            render 'new'
        end
    end
    
    def edit
        #@recipe = Recipe.find(params[:id])
    end
    
    def update
        #@recipe = Recipe.find(params[:id])
        if @recipe.update(recipe_params)
            flash[:success] = "Your recipe was updated successfully"
            redirect_to recipe_path(@recipe)
        else
            render 'edit'
        end
    end
    
    def like
        #@recipe = Recipe.find(params[:id])
        like = Like.create(like: params[:like], chef: current_user, recipe: @recipe)
        
        if like.valid?
            flash[:success] = "Your selection was successfull"
            redirect_to :back
        else
            flash[:danger] = "You can only like/dislike a recipe once"
            redirect_to :back
        end
    end
    
    def destroy
        Recipe.find(params[:id]).destroy
        flash[:success] = "Recipe deleted"
        redirect_to recipes_path
    end
    
    private
    
        def recipe_params
            params.require(:recipe).permit(:name, :summary, :description, :picture, style_ids: [], ingredient_ids: [])
        end
        
        def set_recipe
             @recipe = Recipe.find(params[:id])
             #handle exception trong truong hop nhap ID tam bay
             rescue
                flash[:danger] = "Opps! Your link is not correct"
                redirect_to root_path
        end
        
        #ban chi dc update cong thuc cua chinh ban
        def require_same_user
            #neu user hien tai ko phai la own va ko phai la admin
            if current_user != @recipe.chef and !current_user.admin?
                flash[:danger] = "You can edit only your own Recipe"
                redirect_to root_path
            end
        end
        
        def require_user_like
            if !logged_in?
                flash[:danger] = "You must be login to perform this action"
                redirect_to :back
            end
        end
        
        def admin_user
            redirect_to recipes_path unless current_user.admin?
        end
end