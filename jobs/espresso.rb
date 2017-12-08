def get_weekly_espresso(http)
 	return 10
 end

current_espresso_weekly = 0



SCHEDULER.every '10m', :first_in => 0 do |job|
	http = create_http

	last_espresso_weekly = current_espresso_weekly
	current_espresso_weekly = get_weekly_espresso(http)
	send_event('espressoTotal', { current: current_espresso_weekly, last: last_espresso_weekly })
end