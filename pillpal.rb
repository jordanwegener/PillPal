require_relative ("lib/app.rb")
require_relative ("lib/med.rb")
require "tty-prompt"

pillpal = App.new

case ARGV[0]
when "--add"
  pillpal.add_medication_menu(true)
when "--edit"
  pillpal.medications_menu(true)
when "--week"
  pillpal.schedule_week(true)
when "--sched"
  pillpal.schedule_short(true)
when "--help"
  puts "PillPal is a CLI app to help people remember and manage their medications."
  puts "\n"
  puts "Without arguments, the PillPal menu system will be displayed and all features can be used this way."
  puts "If you prefer, most functionality can be accessed using command line arguments."
  puts "\nArguments:"
  puts "--add       - add a new medication"
  puts "--edit      - show view/edit/delete medications menu"
  puts "--week      - print a 1 week schedule"
  puts "--sched     - print 3, 6, 12 or 24 hour schedules"
  puts "--help      - show help and command line arguments"
  exit
else
  puts "Invalid argument."
  puts "\nArguments:"
  puts "--add       - add a new medication"
  puts "--edit      - show view/edit/delete medications menu"
  puts "--week      - print a 1 week schedule"
  puts "--sched     - print 3, 6, 12 or 24 hour schedules"
  puts "--help      - show help and command line arguments"
  exit
end

pillpal.run
