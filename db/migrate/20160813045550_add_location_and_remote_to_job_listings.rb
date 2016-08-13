class AddLocationAndRemoteToJobListings < ActiveRecord::Migration
  def change
    add_column :job_listings, :location, :string
    add_column :job_listings, :remote, :boolean
  end
end
