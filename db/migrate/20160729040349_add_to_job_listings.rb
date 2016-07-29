class AddToJobListings < ActiveRecord::Migration
  def change
    add_column :job_listings, :favorite, :boolean
    add_column :job_listings, :position, :text
    add_column :job_listings, :posted_date, :date
    add_column :job_listings, :company_website, :string
    add_column :job_listings, :company, :string
  end
end
