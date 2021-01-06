require 'tty-prompt'
require 'rest-client'
require 'json'
#ef6b7de36c8aed58b9210b1226e7bc4d
#api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
ActiveRecord::Base.logger = nil
class Cli  

  def prompt
    TTY::Prompt.new
  end

  def pause
    puts "[Press Enter to Continue]"
    gets
  end

  def welcome
    system('clear')
    
    puts "Welcome to the Ski Resort Weather app!"
    ask = prompt.yes?("Would you like to select a resort?")
    if ask
      @resort_name = list_resorts
      weather @resort_name
    else
      puts "Too bad"
      welcome()
    end
  end

  def list_resorts
    selected_resort = prompt.select("Select resorts", Resort.all.pluck(:name))
  end

  def weather resort_name
    chosen_resort = Resort.all.find_by name: @resort_name
    lat = chosen_resort[:lat]
    long = chosen_resort[:long]
    weather = JSON.parse(RestClient.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=imperial&appid=ef6b7de36c8aed58b9210b1226e7bc4d"))
    current_weather weather
    pause
  end

  def current_weather weather
    puts "The current weather for #{@resort_name} is:"
    puts "Temperature: #{weather["current"]["temp"]}"
    puts "Conditions: #{weather["current"]["weather"][0]["main"]}"
    puts "Wind Speed: #{weather["current"]["wind_speed"]} mph"
  end
end