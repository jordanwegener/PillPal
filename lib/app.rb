# This file contains classes and methods used to run the app
require "tty-prompt"
require_relative ("med.rb")

class App
  def run
    clear
    main_menu
  end

  def main_menu
    puts "-------------- PillPal --------------\n"
    prompt = TTY::Prompt.new
    prompt.select("Please choose from the following options.\n") do |menu|
      menu.choice "Add new medications", 1
      menu.choice "View, edit or delete existing medications", 2
      menu.choice "View and edit medication inventories and rebuy alerts", 3
      menu.choice "Get 3, 6 or 12 hour schedule", 4
      menu.choice "Get 1 week or 2 week schedule", 5
      menu.choice "Exit", 6
    end
  end

  def clear
    system("clear") || system("cls")
  end
end
