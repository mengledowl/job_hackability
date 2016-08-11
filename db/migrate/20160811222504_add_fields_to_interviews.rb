class AddFieldsToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :how_it_went, :integer
    add_column :interviews, :description, :string
  end
end
