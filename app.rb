require 'sinatra'
require 'dropbox_sdk'

def save(params)
  api  = settings.dropbox
  file = "/sugar-flow.txt"

  contents = read_file(api, file)
  contents << "#{parse_record(params)}\n"

  api.put_file file, contents, true
end

def read_file(api, file)
  api.get_file file
rescue DropboxError => e
  return ""
end

def parse_record(params)
  row = ''
  row << params[:type].to_s.ljust(12)
  row << ' | '
  row << params[:time].to_s.ljust(16)
  row << ' | '
  row << params[:log].to_s.ljust(5)
  row << ' | '
  row << params[:note].to_s

  row
end

configure do
  set :dropbox do
    config = YAML.load_file("#{settings.root}/config/dropbox.yml")

    session = DropboxSession.new(config['app_key'], config['app_secret'])
    session.set_access_token(config['access_key'], config['access_secret'])

    DropboxClient.new(session, :dropbox)
  end
end

get '/' do
  erb :index
end

post '/' do
  save params
  redirect to('/')
end
