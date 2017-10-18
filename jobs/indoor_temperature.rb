require 'net/http'
require 'json'

OPENHAB_URI = URI.parse("http://192.168.178.38:8080")
temperatures_entrance = []
temperatures_kitchen = []
xPos = 0
SCHEDULER.every '10m', :first_in => 0 do |job|
	xPos += 1
	http = create_http


 	current_temperature_entrance = get_temperature(http, 'Temperature_Entrance')
	current_temperature_kitchen = get_temperature(http, 'Temperature_Kitchen')

	temperatures_entrance << { x: xPos, y: current_temperature_entrance.to_f }
	temperatures_kitchen << { x: xPos, y: current_temperature_kitchen.to_f }

 	send_event('temperature_entrance', points: temperatures_entrance, last: current_temperature_entrance)
 	send_event('temperature_kitchen', points: temperatures_kitchen, last: current_temperature_kitchen)

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

def get_temperature(http, itemName)
	request = create_request("/rest/items/#{itemName}")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['state']
 end