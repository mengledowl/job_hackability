class Interview < ActiveRecord::Base
  belongs_to :job_listing
  has_many :comments
end
