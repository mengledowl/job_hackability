class NoAdapterFoundError < StandardError
  def initialize(msg="No adapter found")
    super
  end
end