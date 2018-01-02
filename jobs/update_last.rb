require_relative('variable.rb')

# set every last value to the current value once a day
SCHEDULER.every '1d', :first_in => 10 do |job|
  $last_number_of_events_today = $current_number_of_events_today
  $last_number_of_events_tomorrow = $current_number_of_events_tomorrow

  $last_espresso_weekly = $current_espresso_weekly
  $last_espresso_total = $current_espresso_total
end

# set every last value to the current value once every hour
SCHEDULER.every '1h', :first_in => 10 do |job|
  $last_temperature_kitchen = $current_temperature_kitchen
  $last_temperature_entrance = $current_temperature_entrance
end