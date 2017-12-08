def get_current_total_power(http)
	request = create_request("/api/hs110/plugs/powerState")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data.power
 end

current_power_level = 0.0



SCHEDULER.every '15s', :first_in => 0 do |job|
	http = create_http

	last_power_level = current_power_level
	current_power_level = get_calendar_stats(http)
	send_event('electricityTotalCurrent', { current: current_power_level, last: last_power_level })
end