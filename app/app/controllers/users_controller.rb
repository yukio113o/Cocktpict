class UsersController < ApplicationController
    before_action :authenticate_user!
  
    def show
        @user = User.find_by(id: params[:id])
    end
    
    def likes
        @user = User.find_by(id: params[:id])
        @likes = Like.where(user_id: @user.id)
    end
  
    private
     def user_params
        params.require(:user).permit(:name, :email, :profile_photo, :profile)
     end
     
     def post_params
         params.require(:post).permit(:caption, photos_attributes:[:image]).merge(user_id: current_user.id)
     end
end
