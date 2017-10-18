require 'net/http'
require 'json'

OPENHAB_URI = URI.parse("http://192.168.178.38:8080")
current_espressos_total = 0
current_espressos_week = 0
SCHEDULER.every '1m', :first_in => 0 do |job|
	
	http = create_http

	last_espresso_total = current_espressos_total
	last_espresso_week = current_espressos_week

 	current_espressos_total = get_item(http, 'Count_Espresso_Total')
	current_espressos_week = get_item(http, 'Count_Espresso_Week')

 	send_event('espressoTotal', { current: current_espressos_total, last: last_espresso_total })
 	send_event('espressoWeekly', { current: current_espressos_week, last: last_espresso_week })
end


# create HTTP
def create_http
  http = Net::HTTP.new(OPENHAB_URI.host, OPENHAB_URI.port)
  return http
end

# create HTTP request for given path
def create_request(path)
  request = Net::HTTP::Get.new(OPENHAB_URI.path + path)
  return request
end

def get_item(http, itemName)
	request = create_request("/rest/items/#{itemName}")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['state']
 end