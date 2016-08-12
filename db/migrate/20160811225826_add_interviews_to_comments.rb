class AddInterviewsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :interview_id, :integer

    add_index :comments, :interview_id
  end
end
