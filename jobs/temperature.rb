def get_current_temperature(http, location)
	request = create_request("/api/hue/motion/#{location}/temperature")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['temperature']
 end

current_temperature_kitchen = 0.0



SCHEDULER.every '10m', :first_in => 0 do |job|
	http = create_http

	last_temperature_kitchen = current_temperature_kitchen
	current_power_level = get_current_temperature(http, 'kitchen')
	send_event('currentTemperature', { current: current_temperature_kitchen, last: last_temperature_kitchen })
end