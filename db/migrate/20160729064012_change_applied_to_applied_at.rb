class ChangeAppliedToAppliedAt < ActiveRecord::Migration
  def change
    remove_column :job_listings, :applied
    add_column :job_listings, :applied_at, :datetime
  end
end
