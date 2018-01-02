
def get_departures(http)
	request = create_request("/api/mvg/departures/Olympiazentrum/subway?formatDashboard=true&limit=5")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data
 end


# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  http = create_http
  departures = get_departures(http)
  puts departures
  send_event('subwayDepartures', { items: departures })

end