class Admin::PostsController < Admin::AdminController
  respond_to :html

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post]) do |post|
      post.user = current_user
    end
    @post.save
    respond_with @post, location: admin_posts_url
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_with @post
  end
end
