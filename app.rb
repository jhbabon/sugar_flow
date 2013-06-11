require 'sinatra'
require 'dropbox_sdk'

require './lib/record'
require './lib/mapper'
require './lib/parser'
require './lib/dropbox_proxy'

use Rack::Auth::Basic, "Authentication required" do |username, password|
  username == ENV['AUTH_USER'] && password == ENV['AUTH_PASS']
end

configure :development do
  set :dropbox do
    DropboxProxy.new
  end
end

configure :production do
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

configure do
  set :mapper do
    Mapper.new(settings.dropbox)
  end
end

get '/' do
  erb :index
end

post '/record' do
  record = Record.new(params)
  settings.mapper.update record.to_s

  redirect to('/')
end

get '/graphs' do
  parser = Parser.call(settings.mapper.read_io)

  erb :graphs, locals: {
    data: JSON.generate(parser.blood_sugar),
    insulin: JSON.generate(parser.insulin),
  }
end
