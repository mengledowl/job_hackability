class Comment < ActiveRecord::Base
  belongs_to :job_listing
  belongs_to :interview
  belongs_to :user
end
