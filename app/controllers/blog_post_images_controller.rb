class BlogPostImagesController < ApplicationController
  before_action :friendly_find_blog_post
  load_and_authorize_resource :blog_post
  load_and_authorize_resource :blog_post_image, through: :blog_post
  before_action :set_title

  def index
  end

  def new
  end

  def create
    if @blog_post_image.save
      redirect_to blog_post_blog_post_images_path(@blog_post), notice: 'Blog post image was successfully created.'
    else
      render action: "new"
    end
  end

  private
    def friendly_find_blog_post
      @blog_post = BlogPost.friendly.find(params[:blog_post_id])
    end

    def blog_post_image_params
      params.require(:blog_post_image).permit(:blog_post_id, :image)
    end

    def set_title
      @title = "Blog Post Images"
    end
end
