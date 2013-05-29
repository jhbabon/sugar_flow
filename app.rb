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
    session = DropboxSession.new(
      ENV['DROPBOX_APP_KEY'],
      ENV['DROPBOX_APP_SECRET']
    )
    session.set_access_token(
      ENV['DROPBOX_ACCESS_KEY'],
      ENV['DROPBOX_ACCESS_SECRET']
    )

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

get '/graphs' do
  erb :graphs
end
