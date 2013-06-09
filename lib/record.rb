class Record
  def initialize(attributes = nil)
    @attributes = attributes || {}
  end

  def to_s
    array = []
    array << @attributes[:type].to_s.ljust(12)
    array << @attributes[:time].to_s.ljust(16)
    array << @attributes[:log].to_s.ljust(5)
    array << @attributes[:note].to_s

    array.join(' | ')
  end
end
