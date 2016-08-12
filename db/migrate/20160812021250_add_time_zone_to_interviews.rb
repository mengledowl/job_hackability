class AddTimeZoneToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :time_zone, :string
  end
end
