class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i(create destroy)
  
  def create
    @like = current_user.likes.build(like_params)
    @post = @like.post
    if @like.save
      respond_to :js
    end
  end
  
  def destroy
    @like = Like.find_by(id: params[:id])
    @post = @like.post
    if @like.destroy
      respond_to :js
    end
  end
  
  private
    def like_params
      params.permit(:post_id)
    end
    
    def set_post
      @post = Post.find(params[:post_id])
    end
  
end
