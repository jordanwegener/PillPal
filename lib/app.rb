# This file contains classes and methods used to run the app
require "tty-prompt"
require_relative ("med.rb")

class App
  def initialize
    @prompt = TTY::Prompt.new(symbols: { marker: "→" })
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
      menu.choice "Add new medications", 1, disabled: "(not yet implemented)"
      menu.choice "View, edit or delete existing medications", 2, disabled: "(not yet implemented)"
      menu.choice "View and edit medication inventories and rebuy alerts", 3, disabled: "(not yet implemented)"
      menu.choice "Get 3, 6 or 12 hour schedule", 4, disabled: "(not yet implemented)"
      menu.choice "Get 1 week or 2 week schedule", 5, disabled: "(not yet implemented)"
      menu.choice "Exit", 6
    end
    process_menu_input(choice)
  end

  def titlebar
    puts "-------------- PillPal --------------\n\n"
  end

  def process_menu_input(input)
    case input
    when 1
      add_medication
    when 2
      medications_menu
    when 3
      inventory_menu
    when 4
      short_schedule_menu
    when 5
      long_schedule_menu
    when 6
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

  def clear
    system("clear") || system("cls")
  end
end
