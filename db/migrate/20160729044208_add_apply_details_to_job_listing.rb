class AddApplyDetailsToJobListing < ActiveRecord::Migration
  def change
    add_column :job_listings, :apply_details, :text
  end
end
