require 'sinatra'
require 'json'
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'lib/weather'

get '/' do
  erb :index
end

get '/weather.?:format?' do
  content_type :json
  weather = Weather.new
  out = weather.forecast
  out.to_json
end
