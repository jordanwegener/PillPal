require_relative ("lib/app.rb")
require_relative ("lib/med.rb")
require "tty-prompt"

pillpal = App.new

case ARGV[0]
when "add"
  pillpal.add_medication_menu(true)
when "edit"
  pillpal.medications_menu(true)
when "week"
  pillpal.schedule_week(true)
when "sched"
  pillpal.schedule_short(true)
else
  puts "Invalid argument."
end

pillpal.run
