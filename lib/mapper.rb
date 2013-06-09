require 'stringio'

# Maps strings to the actual storage system.
class Mapper

  # Creates a new mapper instance.
  #
  # @param [#put_file, #get_file] api the real api to the storage.
  # @param [String, nil] file the name of the file for the storage
  #   (default: '/sugar-flow.txt').
  def initialize(api, file = nil)
    @api  = api
    @file = '/sugar-flow.txt'
  end

  # Reads the storage content as a String
  #
  # @return [String]
  def read_string
    @api.get_file(@file)
  rescue DropboxError => e
    return ""
  end
  alias_method :read, :read_string

  # Reads the storage content as a StringIO.
  #
  # @return [StringIO]
  def read_io
    StringIO.new(self.read_string)
  end

  # Saves the new data.
  #
  # @param [String] data
  def save(data)
    @api.put_file(@file, data, true)
  end

  # Updates data with the content.
  #
  # @param [String] content
  def update(content)
    data = self.read_string
    data << content

    self.save(data)
  end
end
