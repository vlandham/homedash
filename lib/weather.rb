require 'typhoeus'
# require 'chronic'

# darksky gem had the wrong url for some reason. so replicate functionality here
class Weather
  DARKSKY_API_URL = "https://api.forecast.io"
  DARKSKY_API_KEY = 'b5b363be967c3eca49352ea7488a4645'
  DEFAULT_OPTIONS = {}
  def initialize
    @location = [47.674710384456525, -122.39099356520455]
    @last_call = nil
    @prev_forecast = nil
    # @location = [47.67, -122.39]
  end

  def forecast
    now = Time.now()
    puts "forecast"
    # if @last_call and (now - @last_call) > 100
      puts "calling again"
      options = {}
      response = Typhoeus::Request.get("#{DARKSKY_API_URL}/forecast/#{DARKSKY_API_KEY}/#{@location[0]},#{@location[1]}", DEFAULT_OPTIONS.dup.merge(options))
      @last_call = now
      @prev_forecast = JSON.parse(response.body) if response.code == 200
    # end
    @prev_forecast
  end

  # def get_hours
  #   hours = (0..7).to_a.collect {|h| Chronic.parse("#{h} hours ago").utc.to_i}
  #   hours = hours.reverse
  #   hours << Chronic.parse("in 60 minutes").utc.to_i
  #   hours
  # end
end
