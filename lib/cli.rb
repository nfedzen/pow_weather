require 'tty-prompt'
require 'rest-client'
require 'json'
require 'date'

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

  def options resort_name
    chosen_option = prompt.select("Which weather forecast would you like?", ["Current weather", "3 Day Forecast", "5 Day Forecast", "7 Day Forecast"])
    if chosen_option == "Current weather"
      current_weather @weather
    elsif chosen_option == "3 Day Forecast"
      three_day_forecast @weather
    elsif chosen_option == "5 Day Forecast"
      five_day_forecast @weather 
    else  
      seven_day_forecast @weather 
    end
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
    end
  end

  def list_resorts
    selected_resort = prompt.select("Select resorts", Resort.all.pluck(:name))
  end

  def weather resort_name
    chosen_resort = Resort.all.find_by name: @resort_name
    lat = chosen_resort[:lat]
    long = chosen_resort[:long]
    @weather = JSON.parse(RestClient.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=imperial&appid=ef6b7de36c8aed58b9210b1226e7bc4d"))
    options resort_name
  end

  def current_weather weather
    clear
    puts "The current weather for #{@resort_name} is:"
    puts "\n"
    puts "Temperature: #{weather["current"]["temp"]}\xC2\xB0 F"
    puts "Conditions: #{weather["current"]["weather"][0]["main"]}"
    puts "Wind Speed: #{weather["current"]["wind_speed"]} mph"
    puts "\n"
  end

  def three_day_forecast weather
    clear
    puts "The three day weather forecast for #{@resort_name} is:"
    puts "\n"
    weather["daily"][1..3].each do |day|
      puts "Day: #{dateTime("#{day["dt"]}")}"
      puts "Average Temperature: #{day["temp"]["day"]}\xC2\xB0 F" 
      puts "Low: #{day["temp"]["min"]}\xC2\xB0 F" 
      puts "High: #{day["temp"]["max"]}\xC2\xB0 F"
      puts "Conditions: #{day["weather"][0]["main"]}"
      if day["weather"][0]["main"] == "Snow"
        puts "Amount of Fresh Pow: #{day["snow"]} in"
      end
      puts "Wind Speed: #{day["wind_speed"]} mph"
      puts "\n"
    end
  end

  def five_day_forecast weather
    clear
    puts "The five day weather forecast for #{@resort_name} is:"
    puts "\n"
    weather["daily"][1..5].each do |day|
      puts "Day: #{dateTime("#{day["dt"]}")}"
      puts "Average Temperature: #{day["temp"]["day"]}\xC2\xB0 F" 
      puts "Low: #{day["temp"]["min"]}\xC2\xB0 F" 
      puts "High: #{day["temp"]["max"]}\xC2\xB0 F" 
      puts "Conditions: #{day["weather"][0]["main"]} "
      if day["weather"][0]["main"] == "Snow"
        puts "Amount of Fresh Pow: #{day["snow"]} in"
      end
      puts "Wind Speed: #{day["wind_speed"]} mph"
      puts "\n"
    end
  end

  def seven_day_forecast weather
    clear
    puts "The seven day weather forecast for #{@resort_name} is:"
    puts "\n"
    weather["daily"][1..7].each do |day|
      puts "Day: #{dateTime("#{day["dt"]}")}"
      puts "Average Temperature: #{day["temp"]["day"]}\xC2\xB0 F" 
      puts "Low: #{day["temp"]["min"]}\xC2\xB0 F" 
      puts "High: #{day["temp"]["max"]}\xC2\xB0 F"
      puts "Conditions: #{day["weather"][0]["main"]}"
      if day["weather"][0]["main"] == "Snow"
        puts "Amount of Fresh Pow: #{day["snow"]} in"
      end
      puts "Wind Speed: #{day["wind_speed"]} mph"
      puts "\n"
    end
  end





end

