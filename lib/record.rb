# Representation of a blood sugar or insulin record.
class Record

  # Creates a new record instance.
  #
  # @param [Hash, nil] attributes all of them are optional.
  # @option attributes [String] :type 'blood sugar' or 'insulin'.
  # @option attributes [String] :time in the format '%Y-%m-%d %H:%M'.
  # @option attributes [String] :log the actual value of the record.
  # @option attributes [String] :note additional comments.
  def initialize(attributes = nil)
    @attributes = attributes || {}
  end

  # Record as a convenient string.
  #
  # @example
  #   record.to_s
  #   #=> "blood sugar | 2013-04-14 10:00 | 100 | Went to run."
  #
  # @return [String]
  def to_s
    array = []
    array << @attributes[:type].to_s.ljust(12)
    array << @attributes[:time].to_s.ljust(16)
    array << @attributes[:log].to_s.ljust(5)
    array << @attributes[:note].to_s

    array.join(' | ')
  end
end
