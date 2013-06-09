class Analizer
  def self.parse(io)
    instance = new(io)
    instance.parse

    instance
  end

  def initialize(io)
    @io = io

    @blood_sugar_data = []
    @insulin_data     = { levemir: [], novorapid: [] }
  end

  def parse
    @io.each do |line|
      array = line.split('|').map(&:strip)
      if array[0] == 'blood sugar'
        add_blood_sugar(array)
      else
        add_insulin(array)
      end
    end
  end

  def add_blood_sugar(array)
    date = array[1]
    log  = array[2]

    @blood_sugar_data << { x: Time.parse(date).to_i, y: log.to_i }
  end

  def blood_sugar
    [
      {
        key: 'Blood sugar',
        values: @blood_sugar_data,
      }
    ]
  end

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
