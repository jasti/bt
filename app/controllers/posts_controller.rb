class PostsController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  

  def create
    @post = current_user.posts.build(params[:post])
        if @post.save
          flash[:success] = "Post created!"
          redirect_to root_url
        else
          @feed_items = []
          render 'static_pages/home'
        end
  end

  def destroy
      @post.destroy
      redirect_to root_url
    end

    private
      #Use Of Exceptions
      def correct_user
        @post = current_user.posts.find(params[:id])
      rescue
        redirect_to root_url
      end
end