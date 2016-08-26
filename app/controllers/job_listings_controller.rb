class JobListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job_listing, only: [:show, :edit, :update, :delete]

  def index
    @job_listings = current_user.job_listings.where(filter_params).order(created_at: :desc)
  end

  def new
    @job_listing = JobListing.new
  end

  def create
    @job_listing = JobListing.new(listing_params)

    if current_user.job_listings << @job_listing
      redirect_to @job_listing
    else
      flash.now[:error] = 'Could not create job listing'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
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
    params.require(:job_listing).permit(:url, :title, :description, :apply_link, :resume_link, :applied_at, :location, :remote,
                                        :cover_letter_link, :favorite, :position, :posted_date, :company_website, :company, :apply_details)
  end

  def edit_listing_params
    params.require(:job_listing).permit(:title, :description, :apply_link, :resume_link, :applied_at, :status, :location, :remote,
                                        :cover_letter_link, :favorite, :position, :posted_date, :company_website, :company, :apply_details)
  end

  def filter_params
    params.permit(:status, :remote, :favorite).delete_if { |k, v| v.empty? }
  end

  def set_job_listing
    @job_listing ||= JobListing.find_by(user: current_user, id: params[:id])
  end
end
