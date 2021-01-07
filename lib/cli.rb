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
    chosen_option = prompt.select("What do you want to see?", ["Current weather", "3 Day Forecast", "5 Day Forecast", "7 Day Forecast"])
    if chosen_option == "Current weather"
      current_weather @weather
    elsif chosen_option == "3 Day Forecast"
      forecast 3, @weather
    elsif chosen_option == "5 Day Forecast"
      forecast 5, @weather 
    else  
      forecast 7, @weather 
    end
  end

  def welcome
    clear
    puts "Wassup, welcome to Pow Weather!" 
      ask = prompt.yes?("Wanna check the pow?")
      if ask
        @resort_name = list_resorts
        weather @resort_name
        options @resort_name
      else
        puts "Go get that fresh butter!"
      end
  end

  def list_resorts
    selected_resort = prompt.select("Where are you shreddin' the gnar?", Resort.all.pluck(:name))
  end

  def weather resort_name
    chosen_resort = Resort.all.find_by name: @resort_name
    lat = chosen_resort[:lat]
    long = chosen_resort[:long]
    @weather = JSON.parse(RestClient.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=imperial&appid=ef6b7de36c8aed58b9210b1226e7bc4d"))
  end

  def current_weather weather
    clear
    puts "The current weather for #{@resort_name} is:"
    puts "\n"
    puts "Temperature: #{weather["current"]["temp"]}\xC2\xB0 F"
    puts "Conditions: #{weather["current"]["weather"][0]["main"]}"
    puts "Wind Speed: #{weather["current"]["wind_speed"]} mph"
    puts "\n"
    pause
    welcome
  end


  def forecast days, weather
    clear
    puts "The #{days} day weather forecast for #{@resort_name} is:"
    weather["daily"][1..days].each do |day|
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
    pause
    welcome
  end



end

