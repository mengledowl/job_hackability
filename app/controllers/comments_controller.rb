class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @job_listing = JobListing.find_by(user: current_user, id: params[:job_listing_id])
    @comment = Comment.new(job_listing: @job_listing)
  end

  def show
  end

  def create
    @job_listing = JobListing.find_by(user: current_user, id: params[:job_listing_id])

    if @job_listing
      Comment.create(comment_params)

      redirect_to job_listing_comments_path(@job_listing)
    else
      flash.now[:error] = 'Could not post comment'
      render :index
    end
  end

  def update
  end

  def delete
  end

  private

  def comment_params
    params.require(:comment).permit(:value, :job_listing_id)
  end
end
