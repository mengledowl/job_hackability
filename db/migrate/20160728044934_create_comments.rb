class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :job_listing_id
      t.integer :user_id
      t.text :value

      t.timestamps null: false

      t.index :job_listing_id
    end
  end
end
