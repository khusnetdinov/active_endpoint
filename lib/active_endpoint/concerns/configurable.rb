module Configurable
  def configure
    yield self
  end
end