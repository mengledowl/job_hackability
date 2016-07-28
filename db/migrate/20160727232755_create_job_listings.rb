class CreateJobListings < ActiveRecord::Migration
  def change
    create_table :job_listings do |t|
      t.text :url
      t.integer :user_id
      t.text :title
      t.text :description
      t.text :raw_scraping_data
      t.text :apply_link
      t.text :resume_link
      t.boolean :applied
      t.text :cover_letter_link

      t.timestamps null: false
    end
  end
end
