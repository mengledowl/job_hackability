class InterviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    @job_listing = JobListing.find_by(user: current_user, id: params[:job_listing_id])
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end
end
