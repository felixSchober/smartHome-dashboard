def get_harmony_state(http)
	request = create_request("/api/harmony/activity/current")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data
 end


SCHEDULER.every '30s', :first_in => 0 do |job|

	http = create_http
	harmony_state = get_harmony_state(http)

	if harmony_state['activityRunning'] == false
		send_event('tvStatus', {text: 'OFF', status: 'ok'})
		send_event('tv_live', {text: 'OFF', status: 'ok'})
		send_event('tv_prime', {text: 'OFF', status: 'ok'})
		send_event('tv_apple', {text: 'OFF', status: 'ok'})
		send_event('tv_netflix', {text: 'OFF', status: 'ok'})
		send_event('tv_xbox', {text: 'OFF', status: 'ok'})
	else
		current_activity = harmony_state['activity']

		if current_activity == 'Fehrnsehen'
			send_event('tv_live', {text: 'ON', status: 'danger'})

			# turn off others
			send_event('tv_prime', {text: 'OFF', status: 'ok'})
			send_event('tv_apple', {text: 'OFF', status: 'ok'})
			send_event('tv_netflix', {text: 'OFF', status: 'ok'})
			send_event('tv_xbox', {text: 'OFF', status: 'ok'})

		elsif current_activity == 'Amazon Video'
			send_event('tv_prime', {text: 'ON', status: 'danger'})

			# turn off others
			send_event('tv_live', {text: 'OFF', status: 'ok'})
			send_event('tv_apple', {text: 'OFF', status: 'ok'})
			send_event('tv_netflix', {text: 'OFF', status: 'ok'})
			send_event('tv_xbox', {text: 'OFF', status: 'ok'})

		elsif current_activity == 'Apple TV sehen'
			send_event('tv_apple', {text: 'ON', status: 'danger'})

			# turn off others
			send_event('tv_live', {text: 'OFF', status: 'ok'})
			send_event('tv_prime', {text: 'OFF', status: 'ok'})
			send_event('tv_netflix', {text: 'OFF', status: 'ok'})
			send_event('tv_xbox', {text: 'OFF', status: 'ok'})

		elsif current_activity == 'Netflix'
			send_event('tv_netflix', {text: 'ON', status: 'danger'})

			# turn off others
			send_event('tv_live', {text: 'OFF', status: 'ok'})
			send_event('tv_prime', {text: 'OFF', status: 'ok'})
			send_event('tv_apple', {text: 'OFF', status: 'ok'})
			send_event('tv_xbox', {text: 'OFF', status: 'ok'})

		elsif current_activity == 'XBOX'
			send_event('tv_xbox', {text: 'ON', status: 'danger'})

			# turn off others
			send_event('tv_live', {text: 'OFF', status: 'ok'})
			send_event('tv_prime', {text: 'OFF', status: 'ok'})
			send_event('tv_apple', {text: 'OFF', status: 'ok'})
			send_event('tv_netflix', {text: 'OFF', status: 'ok'})

		end
		send_event('tvStatus', {text: current_activity})

	end
end