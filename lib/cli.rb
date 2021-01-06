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

  def clear 
    system("clear")
  end

  def dateTime epoch
    date_time = DateTime.strptime(epoch,'%s')
    date_time.to_date
  end

  def welcome
    clear
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
    puts "Temperature: #{weather["current"]["temp"]} \xC2\xB0 F"
    puts "Conditions: #{weather["current"]["weather"][0]["main"]}"
    puts "Wind Speed: #{weather["current"]["wind_speed"]} mph"
  end

  def three_day_forecast weather
    weather["daily"][1..3].each do |day|
      puts "Day: #{dateTime("#{day["dt"]}")}"
      puts "Temperature: #{day["temp"]["day"]}\xC2\xB0 F" 
      puts "Temperature minimum: #{day["temp"]["min"]}\xC2\xB0 F" 
      puts "Temperature maximum: #{day["temp"]["max"]}\xC2\xB0 F"
      puts "Conditions: #{day["weather"][0]["main"]}"
      puts "Wind Speed: #{day["wind_speed"]} mph"
    end
  end

  def seven_day_forecast weather
    weather["daily"][1..7].each do |day|
      puts "Day: #{dateTime("#{day["dt"]}")}"
      puts "Temperature: #{day["temp"]["day"]}\xC2\xB0 F" 
      puts "Temperature minimum: #{day["temp"]["min"]}\xC2\xB0 F" 
      puts "Temperature maximum: #{day["temp"]["max"]}\xC2\xB0 F"
      puts "Conditions: #{day["weather"][0]["main"]}"
      puts "Wind Speed: #{day["wind_speed"]} mph"
    end
  end

end

