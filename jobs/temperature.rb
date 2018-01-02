def get_current_temperature(http, location)
	request = create_request("/api/hue/sensors/#{location}/temperature")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['temperature']
 end

SCHEDULER.every '10m', :first_in => 0 do |job|
	http = create_http
	$current_temperature_kitchen = get_current_temperature(http, 'kitchen').round(1)
	$current_temperature_entrance = get_current_temperature(http, 'entrance').round(1)
	send_event('currentTemperatureKitchen', { current: $current_temperature_kitchen, last: $last_temperature_kitchen })
	send_event('currentTemperatureEntrance', { current: $current_temperature_entrance, last: $last_temperature_entrance })

end