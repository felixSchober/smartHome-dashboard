require_relative('variable.rb')

def get_weekly_espresso(http)
	request = create_request("/api/espresso/statistic/week")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['value'].to_i
end

def get_total_espresso(http)
	request = create_request("/api/espresso/statistic/total")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['value'].to_i
 end

 def get_espresso_state(http)
	request = create_request("/api/espresso/machine/Krupps/state/")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['state']
 end

 def get_espresso_countdown_state(http)
	request = create_request("/api/espresso/machine/Krupps/state/countdown")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['seconds'].to_i
 end

SCHEDULER.every '10m', :first_in => 0 do |job|
	http = create_http

	$current_espresso_weekly = get_weekly_espresso(http)
	$current_espresso_total = get_total_espresso(http)

	current_state = get_espresso_state(http)
	countdown = get_espresso_countdown_state(http)

	if current_state == true
		send_event('espresso_currentStatus', {text: 'ON', status: 'danger'})
	else
		send_event('espresso_currentStatus', {text: 'OFF', status: 'ok'})
	end

	send_event('espresso_cleanStatus', { current: countdown})
	send_event('espresso_plus10', { current: countdown })
	send_event('espresso_plus50', { current: countdown })

	send_event('espressoTotal', { current: $current_espresso_total, last: $last_espresso_total })
	send_event('espressoWeek', { current: $current_espresso_weekly, last: $last_espresso_weekly })
end
