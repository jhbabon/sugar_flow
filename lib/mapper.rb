require 'stringio'

class Mapper
  def initialize(api, file = nil)
    @api  = api
    @file = '/sugar-flow.txt'
  end

  def read_string
    @api.get_file @file
  rescue DropboxError => e
    return ""
  end
  alias_method :read, :read_string

  def read_io
    StringIO.new(self.read_string)
  end

  def save(data)
    @api.put_file @file, data, true
  end

  def update(content)
    data = self.read_string
    data << content

    self.save data
  end
end
