##
# Gives us a hash that acts like an ActiveRecord dataset (sort of)
#
class ARLike

  attr_accessor :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def [](key)
    attributes[key]
  end

  def []=(key, value)
    attributes[key] = value
  end
end