class Interview < ActiveRecord::Base
  belongs_to :job_listing
  has_many :comments

  validates_inclusion_of :how_it_went, in: 1..3, allow_nil: true, message: 'should be between 1 and 3'

end
