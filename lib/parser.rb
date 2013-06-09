# Parses data given the in a IO object.
#
# @example data from a dropbox file
#   blood sugar  | 2013-05-27 20:46 | 167   |
#   insulin      | 2013-05-27 20:50 | 8 L   |
#   insulin      | 2013-05-27 20:50 | 9 N   |
#
# For the moment, the data structure and the type
# of insulins is fixed.
class Parser

  # Parses an IO object and returns the instance with
  # the parsed data.
  #
  # @param [IO, #each] io IO object.
  #
  # @return [Parser] instance of the class.
  def self.call(io)
    instance = new(io)
    instance.call

    instance
  end

  # An instance is bound to a IO object.
  #
  # @param [IO, #each] io IO object.
  def initialize(io)
    @io = io

    @blood_sugar_data = []
    @insulin_data     = { levemir: [], novorapid: [] }
  end

  # Inits the parsing
  def call
    @io.each do |line|
      array = line.split('|').map(&:strip)
      if array[0] == 'blood sugar'
        add_blood_sugar(array)
      else
        add_insulin(array)
      end
    end
  end

  # Add a blood sugar record to the global count.
  #
  # @param [Array] array the record data. It
  #   follows the form: [type, date, log, note]
  def add_blood_sugar(array)
    date = array[1]
    log  = array[2]

    @blood_sugar_data << { x: Time.parse(date).to_i, y: log.to_i }
  end
  protected :add_blood_sugar

  # Add an insulin record to the global count.
  #
  # @param [Array] array the record data. It
  #   follows the form: [type, date, log, note]
  def add_insulin(array)
    date = array[1]
    log, type = array[2].split(' ')

    data = { x: Time.parse(date).to_i, y: log.to_i }

    case type.downcase
    when 'n'
      @insulin_data[:novorapid] << data
    when 'l'
      @insulin_data[:levemir] << data
    end
  end
  protected :add_insulin

  # Array with all the parsed records of blood sugar.
  #
  # It follows the convention to be used by a Graph library.
  #
  # @example
  #   parser.blood_sugar
  #   #=> [{ key: 'Blood sugar', values: [{x: 1234, y: 100}, {x: 1234, y: 10}]}]
  #
  # @return [Array] the data, an array formed by hashes.
  def blood_sugar
    [
      {
        key: 'Blood sugar',
        values: @blood_sugar_data,
      }
    ]
  end

  # Array with all the parsed records of insulin.
  #
  # It follows the convention to be used by a Graph library.
  #
  # @example
  #   parser.insulin
  #   #=> [{ key: 'Novorapid', values: [{x: 1234, y: 10} ]},
  #   #=>  { key: 'Levemir',   values: [{x: 1234, y: 10} ]}]
  #
  # @return [Array] the data, an array formed by hashes.
  def insulin
    [
      {
        key: 'Novorapid',
        values: @insulin_data[:novorapid],
      },
      {
        key: 'Levemir',
        values: @insulin_data[:levemir],
      },
    ]
  end
end
