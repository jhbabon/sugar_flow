require 'sinatra'
require 'dropbox_sdk'

require './lib/record'
require './lib/mapper'
require './lib/analizer'

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

  set :mapper do
    Mapper.new(settings.dropbox)
  end
end

get '/' do
  erb :index
end

post '/' do
  record = Record.new(params)
  settings.mapper.update record.to_s

  redirect to('/')
end

get '/graphs' do
  analizer = Analizer.parse(settings.mapper.read_io)

  erb :graphs, locals: {
    data: JSON.generate(analizer.blood_sugar),
    insulin: JSON.generate(analizer.insulin),
  }
end
