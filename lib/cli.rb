require 'tty-prompt'
require 'rest-client'
require 'json'
require 'date'
require 'tty-spinner'


ActiveRecord::Base.logger = nil

class Cli  

  def prompt
    TTY::Prompt.new(symbols: {marker: '🏂'})
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
    date_time.strftime "%m-%d-%Y"
  end

  def dateHour epoch
    date_time = DateTime.strptime(epoch,'%s')
    date_time.strftime "%m-%d-%Y %H:%M:%S"
  end

  def options resort_name
    chosen_option = prompt.select("What do you want to see?", ["Current weather", "Today's 12 Hour Forecast", "3 Day Forecast", "5 Day Forecast", "7 Day Forecast"])
    if chosen_option == "Current weather"
      current_weather @weather
    elsif chosen_option == "3 Day Forecast"
      forecast 3, @weather
    elsif chosen_option == "5 Day Forecast"
      forecast 5, @weather 
    elsif chosen_option == "Today's 12 Hour Forecast"
      hourly @weather
    else  
      forecast 7, @weather 
    end
  end

  def welcome
    clear
    banner
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
    selected_resort = prompt.select("Where are you shreddin' the gnar?", Resort.all.pluck(:name), per_page: 10 )          
  end
  
  def resort_listing 
    Resort.all.pluck(:name)
  end

  def weather resort_name
    chosen_resort = Resort.all.find_by name: @resort_name
    lat = chosen_resort[:lat]
    long = chosen_resort[:long]
    @weather = JSON.parse(RestClient.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=imperial&appid=ef6b7de36c8aed58b9210b1226e7bc4d"))
  end

  def current_weather weather
    clear
    banner
    puts "The current weather for #{@resort_name} is:"
    puts "\n"
    puts "Temperature: #{weather["current"]["temp"]}\xC2\xB0 F"
    puts "Conditions: #{weather["current"]["weather"][0]["main"]}"
    puts "Wind Speed: #{weather["current"]["wind_speed"]} mph 💨"
    puts "\n"
    pause
    welcome
  end


  def forecast days, weather
    clear
    banner
    puts "The #{days} day weather forecast for #{@resort_name} is:"
    puts "\n"
    weather["daily"][1..days].each do |day|

      puts "Day: #{dateTime("#{day["dt"]}")} 🗓"
      puts "Temperature: #{day["temp"]["day"]}\xC2\xB0 F "    #should it be average temp??
      puts "Low: #{day["temp"]["min"]}\xC2\xB0 F 🔽" 
      puts "High: #{day["temp"]["max"]}\xC2\xB0 F 🔼"

      puts "Conditions: #{day["weather"][0]["main"]}"
      if day["weather"][0]["main"] == "Snow"
        puts "Amount of Fresh Pow: #{day["snow"]} in 🌨"
      end
      puts "Wind Speed: #{day["wind_speed"]} mph 💨"
      puts "\n"
    end
    pause
    welcome
  end

  def hourly weather
    clear
    banner
    puts "Today's 12 hour weather forecast for #{@resort_name} is:"
    weather["hourly"][0..11].each do |hour|

      puts "Day: #{dateHour("#{hour["dt"]}")} 🗓"
      puts "Temperature: #{hour["temp"]}\xC2\xB0 F" 

      puts "Feels like: #{hour["feels_like"]}\xC2\xB0 F"
      puts "Conditions: #{hour["weather"][0]["main"]}"
      if hour["weather"][0]["main"] == "Snow"
        puts "Amount of Fresh Pow: #{hour["snow"]} in 🌨"
      end
      puts "Wind Speed: #{hour["wind_speed"]} mph 💨"
      puts "\n"
    end
    pause
    welcome
  end

  
  def sign_in
    clear
    banner
    mountain = prompt.decorate('🏔')
    puts "Wassup, welcome to Pow Weather!" 
    puts "Sign into the app"
    username = prompt.ask("What is your username?")
    user_lookup = User.find_by(username: username)
    if user_lookup 
      password = prompt.mask("What is your password?", mask: mountain) 
      checking_password username, password
    else
      puts "#{username} not found"
      new_user = prompt.yes?("Would you like to create a new user profile?")
        if new_user
          create_user_profile
        else
          puts "Continue as guest"
          pause
        end
    end
  end


  def checking_password username, password
    mountain = prompt.decorate('🏔')
    pass_lookup = User.find_by(password_string: password)
    if pass_lookup
      puts "Congratulations, you logged in!" 
      puts "Welcome #{username}!"
    else
      puts "Incorrect Password, try again"
      pause
      password = prompt.mask("What is your password?", mask: mountain)
      pass_lookup = User.find_by(password_string: password)
        if pass_lookup
          puts "Congratulations, you logged in!" 
          pause
        else 
          puts "Incorrect Password, try signing in again"
          pause
          sign_in
        end
    end
  end  


  def create_user_profile
    mountain = prompt.decorate('🏔')
    desired_username = prompt.ask("What is your desired username?")
      desired_username_search desired_username 
    desired_password = prompt.mask("Now lets create your password:", mask: mountain)
    user_age = prompt.ask("What is your age?")
    user_location = prompt.ask("Where are you located?")
    select_favorite = prompt.yes?("Would you like to select your favorite Colorado resorts?")
      if select_favorite
        user_fav = prompt.multi_select("Select your favorite resorts?", resort_listing)
      end
    puts "\n"
    user_creation_spinner
    puts "\n"
    User.create username: desired_username, password_string: desired_password, age: user_age, location: user_location, favorite_resort: user_fav
    puts "⛷  ⛷  ⛷  Time to shred the gnar ⛷  ⛷  ⛷"
    puts "\n"
    puts " Please sign into your new user profile "
    puts "\n"
    pause 
    sign_in
  end

  def user_creation_spinner
    spinner = TTY::Spinner.new("[:spinner] Creating user profile ...", format: :spin_2)
    spinner.auto_spin 
    sleep(2) 
    spinner.stop("Done!") 
  end
  
  def desired_username_search username 
    username_lookup = User.find_by(username: username)
    if username_lookup
      puts "Sorry, that username is already taken, try again"
        username = prompt.ask("What is your desired username?")
        username_lookup = User.find_by(username: username)
    end
  end

  
 
  def banner
    box = TTY::Box.frame(width: 150, height: 18, border: :thick, align: :center) do
        "
              :                                                                                                               
             t#,                                                    ,;                                           ,;           
 t          ;##W.                                                 f#i                        .    .            f#i j.         
 ED.       :#L:WE             ;                     ;           .E#t             .. GEEEEEEELDi   Dt         .E#t  EW,        
 E#K:     .KG  ,#D          .DL                   .DL          i#W,             ;W, ,;;L#K;;.E#i  E#i       i#W,   E##j       
 E##W;    EE    ;#f f.     :K#L     LWL   f.     :K#L     LWL L#D.             j##,    t#E   E#t  E#t      L#D.    E###D.     
 E#E##t  f#.     t#iEW:   ;W##L   .E#f    EW:   ;W##L   .E#f:K#Wfff;          G###,    t#E   E#t  E#t    :K#Wfff;  E#jG#W;    
 E#ti##f :#G     GK E#t  t#KE#L  ,W#;     E#t  t#KE#L  ,W#; i##WLLLLt       :E####,    t#E   E########f. i##WLLLLt E#t t##f   
 E#t ;##D.;#L   LW. E#t f#D.L#L t#K:      E#t f#D.L#L t#K:   .E#L          ;W#DG##,    t#E   E#j..K#j...  .E#L     E#t  :K#E: 
 E#ELLE##K:t#f f#:  E#jG#f  L#LL#G        E#jG#f  L#LL#G       f#E:       j###DW##,    t#E   E#t  E#t       f#E:   E#KDDDD###i
 E#L;;;;;;, f#D#;   E###;   L###j         E###;   L###j         ,WW;     G##i,,G##,    t#E   E#t  E#t        ,WW;  E#f,t#Wi,,,
 E#t         G#t    E#K:    L#W;          E#K:    L#W;           .D#;  :K#K:   L##,    t#E   f#t  f#t         .D#; E#t  ;#W:  
 E#t          t     EG      LE.           EG      LE.              tt ;##D.    L##,     fE    ii   ii           tt DWi   ,KK: 
                    ;       ;@            ;       ;@                  ,,,      .,,       :                                    
        
  "end
      print box
      puts "\n"
  end
end