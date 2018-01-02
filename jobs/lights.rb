require_relative('variable.rb')

def get_light_data(http)
	request = create_request("/api/hue/lights")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data
end

SCHEDULER.every '20s', :first_in => 0 do |job|
	http = create_http

	last_lights_on = $current_lights_on

	light_data = get_light_data(http)
	$current_lights_on = light_data['lightsOnCount'].to_i

	send_event('lightsOn', { current: $current_lights_on, last: last_lights_on })

end