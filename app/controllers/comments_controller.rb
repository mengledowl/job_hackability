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

    if @job_listing && params[:interview_id].present?
      @interview = Interview.find_by(job_listing: @job_listing, id: params[:interview_id])

      if @interview && @interview.comments << Comment.new(comment_params)
        redirect_to job_listing_interview_path(id: @interview.id)
      else
        flash.now[:error] = 'Could not post comment'
        render 'interviews/show'
      end
    else
      if @job_listing
        @job_listing.comments << Comment.new(comment_params)

        redirect_to job_listing_comments_path(@job_listing)
      else
        flash.now[:error] = 'Could not post comment'
        render :index
      end
    end
  end

  def update
  end

  def delete
  end

  private

  def comment_params
    params.require(:comment).permit(:value)
  end
end
