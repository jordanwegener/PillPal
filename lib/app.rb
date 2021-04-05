# This file contains classes and methods used to run the app
require "tty-prompt"
require "tod"
require "io/console"
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
      menu.per_page 10
      menu.choice "Add new medications", 1
      menu.choice "View, edit or delete existing medications", 2
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
    puts "Add medication taken on weekly schedule\n\n"
    medication_name = @prompt.ask("What is the name of the medication?")
    choices = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    medication_days_taken = @prompt.multi_select("Which days of the week do you take it?", choices, per_page: 7, help: "(Press ↑/↓ arrow keys to navigate, Space to select and Enter to continue)")
    medication_times_taken = time_input
    @medications.push(Medication_weekly.new(medication_name, medication_days_taken, medication_times_taken))
    clear
    titlebar
    puts "Medication added!\n"
    medications.last.display_medication
    continue
  end

  def add_medication_interval
    clear
    titlebar
    puts "Add medication taken at intervals\n\n"
    medication_name = @prompt.ask("What is the name of the medication?")
    medication_interval = @prompt.ask("How many days between doses? E.g. between Monday and Wednesday is 2 days", convert: :int)
    medication_times_taken = time_input
    @medications.push(Medication_interval.new(medication_name, medication_interval, medication_times_taken))
    puts "Medication added!\n"
    medications.last.display_medication
    continue
  end

  def medications_menu
    loop do
      clear
      titlebar
      puts "View, edit or delete existing medications\n\n"
      choice = @prompt.select("Please select from the following options:\n\n") do |menu|
        menu.help "(Choose using ↑/↓ arrow keys, press Enter to select)"
        menu.show_help :always
        menu.choice "View all medication entries", 1
        menu.choice "Edit a medication entry", 2
        menu.choice "Delete a medication entry", 3
        menu.choice "Back", 4
      end
      case choice
      when 1
        display_all_medications
        continue
      when 2
        display_all_medications
        choice = @prompt.ask("Which entry would you like to edit?", help: "Enter a number to edit or q to cancel. Careful, this is permanent!")
        # if choice.is_a?(Integer)
        #   medications.delete_at(choice.to_i)
        #   puts "/n Entry deleted!"
        #   continue
        # end
      when 3
        display_all_medications
        choice = @prompt.ask("Which entry would you like to delete?", help: "Enter a number to delete or q to cancel. Careful, this is permanent!")
        if choice.to_i.is_a?(Integer)
          medications.delete_at(choice.to_i - 1)
          puts "/n Entry deleted!"
          continue
        end
      when 4
        break
      end
    end
  end

  def display_all_medications
    if medications.length > 0
      puts "Current medications:\n\n"
      i = 1
      medications.each do |medication|
        puts "--------- #{i} ---------"
        medication.display_medication
        puts "\n---------------------\n\n"
        i += 1
      end
    else
      puts "\nThere are no medications yet...\n\n"
      goto_wizard = @prompt.yes?("Would you like to add your first one now?")
      if goto_wizard == true
        add_medication_menu
      else
        clear
        main_menu
      end
    end
  end

  def time_input
    times = []
    input = @prompt.ask("What is the first (or only) time of day you have to take this medication?")
    time = Tod::TimeOfDay.parse(input)
    times.push(time.second_of_day)
    continue = @prompt.yes?("Do you need to add additional times when this medication is taken?")
    if continue == true
      loop do
        input = @prompt.ask("What is the next time of day you need to take this medication?")
        time = Tod::TimeOfDay.parse(input)
        times.push(time.second_of_day)
        continue = @prompt.yes?("Do you need to add additional times when this medication is taken?")
        if continue == false
          break
        end
      end
    end
    return times
  end

  def clear
    system("clear") || system("cls")
  end

  def continue
    print "Press any key to continue..."
    STDIN.getch
  end
end
