class JobListingsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @job_listing = JobListing.new
  end

  def create
    @job_listing = JobListing.new(listing_params)

    if @job_listing.save
      redirect_to @job_listing
    else
      flash.now[:error] = 'Could not create job listing'
      render :new
    end
  end

  def show
  end

  def edit
    @job_listing = JobListing.find(params[:id])
  end

  def update
    @job_listing = JobListing.find(params[:id])

    if @job_listing.update(edit_listing_params)
      redirect_to @job_listing
    else
      flash.now[:error] = 'Could not update job listing'
      render :edit
    end
  end

  def delete
  end

  private

  def listing_params
    params.require(:job_listing).permit(:url, :title, :description, :apply_link, :resume_link, :applied_at,
                                        :cover_letter_link, :favorite, :position, :posted_date, :company_website, :company, :apply_details)
  end

  def edit_listing_params
    params.require(:job_listing).permit(:title, :description, :apply_link, :resume_link, :applied_at,
                                        :cover_letter_link, :favorite, :position, :posted_date, :company_website, :company, :apply_details)
  end
end
