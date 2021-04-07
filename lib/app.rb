# This file contains classes and methods used to run the app
require "tty-prompt"
require "tod"
require "io/console"
require "date"
require "time"
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
      menu.choice "Get 1 week schedule", 5
      menu.choice "Get 3, 6 or 12 hour schedule", 4
      menu.choice "View and edit medication inventories and rebuy alerts", 3, disabled: "(not yet implemented)"
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
      schedule_short
    when 5
      week_schedule
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
    medication_dose = @prompt.ask("What is the dose of each pill?")
    medication_number_taken = @prompt.ask("How many do you take at a time?") do |input|
      input.convert(:int, "Invalid input. Please provide a number.")
    end
    choices = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    medication_days_taken = @prompt.multi_select("Which days of the week do you take it?", choices, per_page: 7, help: "(Press ↑/↓ arrow keys to navigate, Space to select and Enter to continue)")
    medication_times_taken = time_input
    @medications.push(MedicationWeekly.new(medication_name, medication_dose, medication_number_taken, medication_days_taken, medication_times_taken))
    clear
    titlebar
    puts "Medication added!\n\n"
    medications.last.display_medication
    continue
  end

  def edit_medication_weekly(index)
    clear
    titlebar
    puts "Edit medication\n\n"
    medication_name = @prompt.ask("What is the new name of the medication?")
    medication_dose = @prompt.ask("What is the dose of each pill?")
    medication_number_taken = @prompt.ask("How many do you take at a time?") do |input|
      input.convert(:int, "Invalid input. Please provide a number.")
    end
    choices = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    medication_days_taken = @prompt.multi_select("Which days of the week do you take it?", choices, per_page: 7, help: "(Press ↑/↓ arrow keys to navigate, Space to select and Enter to continue)")
    medication_times_taken = time_input
    @medications[index].edit_medication(medication_name, medication_dose, medication_number_taken, medication_days_taken, medication_times_taken)
    clear
    titlebar
    puts "Medication updated!\n\n"
    medications[index].display_medication
    continue
  end

  def add_medication_interval
    clear
    titlebar
    puts "Add medication taken at intervals\n\n"
    medication_name = @prompt.ask("What is the name of the medication?")
    medication_dose = @prompt.ask("What is the dose of each pill?")
    medication_number_taken = @prompt.ask("How many do you take at a time?") do |input|
      input.convert(:int, "Invalid input. Please provide a number.")
    end
    medication_interval = @prompt.ask("How many days between doses? E.g. between Monday and Wednesday is 2 days", convert: :int)
    medication_times_taken = time_input
    medication_date_first_taken = get_date_taken(medication_interval)
    @medications.push(MedicationInterval.new(medication_name, medication_dose, medication_number_taken, medication_interval, medication_times_taken, medication_date_first_taken))
    puts "Medication added!\n\n"
    medications.last.display_medication
    continue
  end

  def edit_medication_interval(index)
    clear
    titlebar
    puts "Edit medication\n\n"
    medication_name = @prompt.ask("What is the new name of the medication?")
    medication_dose = @prompt.ask("What is the dose of each pill?")
    medication_number_taken = @prompt.ask("How many do you take at a time?") do |input|
      input.convert(:int, "Invalid input. Please provide a number.")
    end
    medication_interval = @prompt.ask("How many days between doses? E.g. between Monday and Wednesday is 2 days", convert: :int)
    medication_times_taken = time_input
    @medications[index].edit_medication(medication_name, medication_dose, medication_number_taken, medication_interval, medication_times_taken)
    clear
    titlebar
    puts "Medication updated!\n\n"
    medications[index].display_medication
    continue
  end

  def get_date_taken(medication_interval)
    choices = ["Today", "Tomorrow", "In 2 days", "In 3 days", "In 4 days", "In 5 days", "In 6 days"]
    (choices.length - medication_interval).times { choices.pop }
    choice = @prompt.select("When will you take the first dose?", choices, per_page: 7, help: "(Press ↑/↓ arrow keys to navigate, Space to select and Enter to continue)")
    case choice
    when "Today"
      medication_date_first_taken = Date.today
    when "Tomorrow"
      medication_date_first_taken = Date.today + 1
    when "In 2 days"
      medication_date_first_taken = Date.today + 2
    when "In 3 days"
      medication_date_first_taken = Date.today + 3
    when "In 4 days"
      medication_date_first_taken = Date.today + 4
    when "In 5 days"
      medication_date_first_taken = Date.today + 5
    when "In 6 days"
      medication_date_first_taken = Date.today + 6
    end
    return medication_date_first_taken
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
        choice = @prompt.ask("Which entry would you like to edit?\n\nEnter a number to edit or q to cancel.\nCareful, this is permanent!")
        if choice.is_integer? && choice.to_i > 0
          if medications[choice.to_i - 1].class == MedicationWeekly
            edit_medication_weekly(choice.to_i)
          elsif medications[choice.to_i - 1].class == MedicationInterval
            edit_medication_interval(choice.to_i - 1)
          end
        else
          medications_menu
        end
      when 3
        display_all_medications
        choice = @prompt.ask("Which entry would you like to delete?\n\nEnter a number to delete or q to cancel.\nCareful, this is permanent!")
        if choice.is_integer? && choice.to_i > 0
          medications.delete_at(choice.to_i - 1)
          puts "\nEntry deleted!"
          continue
        else
          medications_menu
        end
      when 4
        break
      end
    end
  end

  def schedule_short
    choice = @prompt.select("What time period would you like to print a schedule for?") do |menu|
      menu.help "(Choose using ↑/↓ arrow keys, press Enter to select)"
      menu.show_help :always
      menu.choice "3 hours", 3
      menu.choice "6 hours", 6
      menu.choice "12 hours", 12
    end
    medications.each do |med|
      med.take_within_hours(choice)
    end
    continue
  end

  def display_all_medications
    if medications.length > 0
      puts "Current medications:\n\n"
      i = 1
      medications.each do |medication|
        puts "--------- #{i} ---------\n"
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
    time_taken = Tod::TimeOfDay.parse(input)
    times.push({ hour: time_taken.hour.to_s.rjust(2, "0"), minute: time_taken.minute.to_s.rjust(2, "0"), second_of_day: time_taken.second_of_day })
    continue = @prompt.yes?("Do you need to add additional times when this medication is taken?")
    if continue == true
      loop do
        input = @prompt.ask("What is the next time of day you need to take this medication?")
        time_taken = Tod::TimeOfDay.parse(input)
        times.push({ hour: time_taken.hour.to_s.rjust(2, "0"), minute: time_taken.minute.to_s.rjust(2, "0"), second_of_day: time_taken.second_of_day })
        continue = @prompt.yes?("Do you need to add additional times when this medication is taken?")
        if continue == false
          break
        end
      end
    end
    return times
  end

  def week_schedule
    clear
    titlebar
    puts "--------- 1 Week Schedule ---------\n\n"
    medications_day = {
      "Sunday" => [],
      "Monday" => [],
      "Tuesday" => [],
      "Wednesday" => [],
      "Thursday" => [],
      "Friday" => [],
      "Saturday" => [],
    }
    today = Date.today
    medications.each do |med|
      if med.class == MedicationInterval
        date_counter = 0
        while date_counter < 7
          if med.check_needed(today + date_counter)
            medications_day[(today + date_counter).strftime("%A")] << med
          end
          date_counter += 1
        end
      elsif med.class == MedicationWeekly
        med.days_taken.each do |day|
          medications_day[day] << med
        end
      end
    end
    schedule_1week = medications_day.to_a.rotate(Date.today.wday)
    schedule_1week.each do |day|
      header = "\n----- #{day.first} -----"
      puts header
      if day.last == []
        puts "\nNo medications\n"
      else
        day.last.each(&:display_medication_short)
      end
      header.length.times do
        print "-"
      end
      puts "\n"
    end
    continue
  end

  def clear
    system("clear") || system("cls")
  end

  def continue
    puts "\n"
    print "Press any key to continue..."
    STDIN.getch
  end
end

class String # This is here to provide a way to check if user input is an integer-like string
  def is_integer?
    self.to_i.to_s == self
  end
end
