class JobListing < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :url, scope: :user
end
