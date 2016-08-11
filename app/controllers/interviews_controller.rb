class InterviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job_listing

  def index
  end

  def show
    @interview = @job_listing.interviews.where(id: params[:id]).first
  end

  def new
    @interview = Interview.new(job_listing: @job_listing)
  end

  def create
    @interview = Interview.new(job_listing: @job_listing)

    Time.use_zone(params[:time_zone]) do
      @interview.attributes = interview_params
    end

    if @interview.save
      redirect_to job_listing_interview_url(job_listing_id: @job_listing.id, id: @interview.id)
    else
      flash.now[:error] = 'Could not save interview'
      render :new
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  private

  def set_job_listing
    @job_listing ||= job_listing
  end

  def job_listing
    JobListing.find_by(user: current_user, id: params[:job_listing_id])
  end

  def interview_params
    params.require(:interview).permit(:scheduled_at, :location)
  end
end
