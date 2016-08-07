class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.integer :job_listing_id
      t.datetime :scheduled_at
      t.string :location

      t.timestamps null: false
    end
  end
end
