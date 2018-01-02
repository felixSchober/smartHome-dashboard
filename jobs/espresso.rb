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


SCHEDULER.every '10m', :first_in => 0 do |job|
	http = create_http

	$current_espresso_weekly = get_weekly_espresso(http)
	$current_espresso_total = get_total_espresso(http)

	send_event('espressoTotal', { current: $current_espresso_total, last: $last_espresso_total })
	send_event('espressoWeek', { current: $current_espresso_weekly, last: $last_espresso_weekly })

end