# This file contains classes and methods used to run the app
require "tty-prompt"
require_relative ("med.rb")

class App
  attr_accessor :medications

  def initialize
    @prompt = TTY::Prompt.new(symbols: { marker: "→" })
    @medications = []
  end

  def run
    loop do
      clear
      main_menu
    end
  end

  def main_menu
    titlebar
    choice = @prompt.select("Please choose from the following options.\n\n") do |menu|
      menu.help "(Choose using ↑/↓ arrow keys, press Enter to select)"
      menu.show_help :always
      menu.choice "Add new medications", 1
      menu.choice "View, edit or delete existing medications", 2, disabled: "(not yet implemented)"
      menu.choice "View and edit medication inventories and rebuy alerts", 3, disabled: "(not yet implemented)"
      menu.choice "Get 3, 6 or 12 hour schedule", 4, disabled: "(not yet implemented)"
      menu.choice "Get 1 week or 2 week schedule", 5, disabled: "(not yet implemented)"
      menu.choice "Get a schedule for a specific date range", 6, disabled: "(not yet implemented)"
      menu.choice "Exit", 7
    end
    process_menu_input(choice)
  end

  def titlebar
    puts "-------------- PillPal --------------\n\n"
  end

  def process_menu_input(input)
    case input
    when 1
      add_medication_menu
    when 2
      medications_menu
    when 3
      inventory_menu
    when 4
      short_schedule_menu
    when 5
      long_schedule_menu
    when 6
      date_range_menu
    when 7
      clear
      titlebar
      puts "Thanks for using PillPal!"
      sleep(2)
      clear
      exit
    else
      puts "Invalid selection" # REPLACE WITH PROPER ERROR HANDLING
    end
  end

  def add_medication_menu
    clear
    titlebar
    puts "---------- Add Medication ----------\n\n"
    choice = @prompt.select("Is your medication taken on certain days of the week or at a certain interval (e.g. once every 3 days)?\n\n") do |menu|
      menu.help "(Choose using ↑/↓ arrow keys, press Enter to select)"
      menu.show_help :always
      menu.choice "Certain days of the week", 1
      menu.choice "Certain interval", 2
      menu.choice "Back", 3
    end
    case choice
    when 1
      add_medication_weekly
    when 2
      add_medication_interval
    when 3
      clear
      main_menu
    end
  end

  def add_medication_weekly
    clear
    titlebar
    medication_name = @prompt.ask("What is the name of the medication?")
    choices = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    medication_days_taken = @prompt.multi_select("Which days of the week do you take it?", choices, per_page: 7)
    medication_times_taken
    puts medication_name
    p medication_days_taken
    sleep(5)
  end

  def time_input
    times = []
    input = @prompt.ask("What is the first time of day you have to take this medication?", default: "24hr time in HH:MM format", convert: :time)
    times.push(input)
    continue = prompt.yes?("Do you need to add additional times when this medication is taken?")
    if continue == true
      loop do
        input = @prompt.ask("What is the next time of day you need to take this medication?" default: "24hr time in HH:MM format", convert: :time)
        times.push(input)
        continue = prompt.yes?("Do you need to add additional times when this medication is taken?")
        if continue == false
          break
    end
    end
  end

  def clear
    system("clear") || system("cls")
  end
end
