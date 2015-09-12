class ChefsController < ApplicationController
    
    before_action :set_chef, only: [:edit, :update, :show]
    before_action :require_user, except: [:show, :index]
    #chi apply cho 2 action edit/update
    before_action :require_same_user, only: [:edit, :update]
    
    def index
        @chefs = Chef.paginate(page: params[:page], per_page: 3)
    end
    
    def new
        @chef = Chef.new
    end
    
    def create
        @chef = Chef.new(chef_params)
        if @chef.save
            flash[:success] = "Your account has been registered"
            session[:chef_id] = @chef.id
            redirect_to recipes_path
        else
            render 'new'
        end
    end
    
    def edit
        #@chef = Chef.find(params[:id])
    end

    def update
        #@chef = Chef.find(params[:id])
        if @chef.update(chef_params)
            flash[:success] = "Your profile has been updated"
            redirect_to chef_path(@chef)
        else
            render 'edit'
        end
    end
    
    def show
        #@chef = Chef.find(params[:id])
        @recipes = @chef.recipes.paginate(page: params[:page], per_page: 3)
    end
    
    private
        def chef_params
            params.require(:chef).permit(:chefname, :email, :password)
        end
        
        def set_chef
            @chef = Chef.find(params[:id])
        end
        
        #ban chi dc update cong thuc cua chinh ban
        def require_same_user
            if current_user != @chef
                flash[:danger] = "You can edit only your own profile"
                redirect_to root_path
            end
        end
        
        def require_user
            if !logged_in?
                flash[:danger] = "You must be login to perform this action"
                redirect_to root_path
            end
        end
end