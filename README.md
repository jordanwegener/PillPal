# PillPal - Medications reminder app for CLI

The purpose of this CLI app is to assist those who, like me, have regularly scheduled medications they need to take and, like me, still manage to forget about them every now and then even though it's a daily routine. I would imagine that if you're like me but have a more extensive regimen than a couple of medications this could be even more problematic for you.

This app is designed for people who have this problem but would prefer to use a simple CLI utility to help.

## Functionality

PillPal allows you to input your medication names, dosages and the times/days you need to take them. This information is stored and can be edited or recalled in a variety of ways. You can ask PillPal to show you your entire weekly schedule or one for 3/6/12/24 hours. You can also simply ask what you need to take in the next 3 or 6 hours, in case you need to leave the house and need a reminder of what you need to pack.

## Installation

### Ruby

To use PillPal you will need to have Ruby 2.7.2 installed.

https://www.ruby-lang.org/en/documentation/installation/

### Dependencies

PillPal uses the following dependencies, which can be installed by running the  ```install-dependencies.sh``` shell script, or from the ```/src``` directory using ```bundle install```:

- tty-prompt (to provide menu functionality)
- Tod (to provide useful time of day classes)
- colorize (to enhance readability of terminal output)

## Usage

### Launching PillPal

You can launch PillPal by either running the included ```pillpal.sh``` script or by running ```ruby pillpal.rb``` from the ```/src``` directory.

### Using menus

Menu navigation is performed using the up and down arrow keys and the spacebar or enter to select an option.

### Adding medications

To add medications, select "Add new medications" from the main menu. This presents a submenu. If your medication is taken on particular days of the week, select "Certain days of the week". If your medication is taken on regular intervals (every x days), select "Certain interval". For both medication types, provide the name of the medication, the dose (e.g. 20mg, kept for your reference) and the amount of pills you take each time you take it.

For weekly medications, you can then select which days of the week you need to take it. Use the up and down arrow keys to move the cursor and press Space to select or unselect a day. Press enter when you have selected all the days you need to take the medication.

For interval medications, you then need to provide the interval in days between times that you take the medication (e.g. if you need to take it on a Monday and then on a Wednesday and then on a Friday ect, the interval would be 2).

For both types, the prompt will ask for times taken. After submitting the first, the prompt will ask if you need to add more times. You can repeat this to add as many times  as you need to. The prompt accepts a variety of formats (e.g. 12 hour with am/pm, 24 hour time, "4p" ect).

There is one more step for interval medications - the prompt will ask you when you will take your next dose of the medication. This is stored so that the application can calculate when you need to take that medication again, based on the interval.

### Viewing, editing and deleting medication entries

To view, edit or delete medication entries, select "View, edit or delete existing medications" from the main menu. This presents a submenu.

- To view all entries and all their associated information, select "View all medication entries". You will be presented with a list of medication entries for your reference.

- To edit, select "Edit a medication entry". You will be presented with a list of medication entries which are each preceded by a number. Provide the number of the entry you wish to edit and press enter, or if you want to cancel type "q" and press enter. The process for editing a medication is identical to the one for adding a new one.

- To edit, select "Delete a medication entry". You will be presented with a list of medication entries which are each preceded by a number. Provide the number of the entry you wish to delete and press enter, or if you want to cancel type "q" and press enter.

### Viewing 1 week and 3/6/12/24 hour schedules

You can ask PillPal to show you a 1 week or a 3/6/12/24 hour schedule. This is useful if you are going away, or if you're heading out and need to see which medications you need to take with you.

- To view a 1 week schedule, select "Get 1 week schedule" from the main menu. A day-by-day schedule starting with today and going for one week will be printed, showing which medications you need to take, how many you need to take at a time and the times you need to take them.

- To view a 3/6/12/24 hour schedule, select "Get 3, 6, 12 or 24 hour schedule" from the main menu. At the prompt, select the time period you wish to view a schedule for. A schedule of the time period you selected will be displayed, showing for each medication which times you need to take it and how many.

### Exiting PillPal

To exit PillPal, choose "Exit" from the main menu.

### Using arguments

PillPal supports several command line arguments so that it can be used without navigating the main menu.

```
--add       - add a new medication
--edit      - show view/edit/delete medications menu
--week      - print a 1 week schedule
--sched     - print 3, 6, 12 or 24 hour schedules
--help      - show help and command line arguments
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)