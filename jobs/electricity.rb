def get_current_total_power(http)
	request = create_request("/api/hs110/plugs/powerState")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['power'].to_i
 end

 def get_power_graph(http, device)
	request = create_request("/api/hs110/plugs/#{device}/powerState/history")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['history']
 end


# single items
current_total_power_level = 0.0
current_espresso_power = 0.0
current_computer_power = 0.0
current_media_power = 0.0
current_kitchen_power = 0.0

# graphs
time_x = 0
power_chart_labels = Array.new(360) { '' }

# create labels
minute_label = -60
for i in 0..360
	if i % 6 == 0
		power_chart_labels[i] = minute_label.to_s + 'm'
		minute_label = minute_label + 1
	end
end

total_power_chart_titles = ['Espresso Machine', 'Media', 'Computer', 'Kitchen']

total_power_chart_data = [
	{
		label: total_power_chart_titles[0],
		data: Array.new(power_chart_labels.length) { 0 },
		backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * power_chart_labels.length,
    	borderColor: [ 'rgba(255, 99, 132, 1)' ] * power_chart_labels.length,
    	borderWidth: 1,
	},
	{
		label: total_power_chart_titles[1],
		data: Array.new(power_chart_labels.length) { 0 },
		backgroundColor: [ 'rgba(255, 206, 86, 0.2)' ] * power_chart_labels.length,
    	borderColor: [ 'rgba(255, 206, 86, 1)' ] * power_chart_labels.length,
    	borderWidth: 1,
	},
	{
		label: total_power_chart_titles[2],
		data: Array.new(power_chart_labels.length) { 0 },
		backgroundColor: [ 'rgba(0, 191, 25, 0.2)' ] * power_chart_labels.length,
    	borderColor: [ 'rgba(0, 191, 25, 1)' ] * power_chart_labels.length,
    	borderWidth: 1,
	},
	{
		label: total_power_chart_titles[3],
		data: Array.new(power_chart_labels.length) { 0 },
		backgroundColor: [ 'rgba(33, 150, 243, 0.2)' ] * power_chart_labels.length,
    	borderColor: [ 'rgba(33, 150, 243, 1)' ] * power_chart_labels.length,
    	borderWidth: 1,
	},
]

charts_options = { }



SCHEDULER.every '10s', :first_in => 0 do |job|
	http = create_http


	# total power level
	last_total_power_level = current_total_power_level
	current_total_power_level = get_current_total_power(http)

	# power level graphs
	total_power_chart_data[0][:data] = get_power_graph(http, 'Espresso')
	total_power_chart_data[1][:data] = get_power_graph(http, 'Media')
	total_power_chart_data[2][:data] = get_power_graph(http, 'Computer')
	total_power_chart_data[3][:data] = get_power_graph(http, 'Kitchen')


	# individual power levels
	last_espresso_power = current_espresso_power
	last_computer_power = current_computer_power
	last_media_power = current_media_power
	last_kitchen_power = current_kitchen_power

	current_espresso_power = total_power_chart_data[0][:data].last.to_i
	current_computer_power = total_power_chart_data[2][:data].last.to_i
	current_media_power = total_power_chart_data[1][:data].last.to_i
	current_kitchen_power = total_power_chart_data[3][:data].last.to_i

	send_event('total_electricity_consumption_graph', { labels: power_chart_labels, datasets: total_power_chart_data, options: charts_options })


	send_event('electricityTotalCurrent', { current: current_total_power_level, last: last_total_power_level })
	send_event('power_espresso', { current: current_espresso_power, last: last_espresso_power })
	send_event('power_computer', { current: current_computer_power, last: last_computer_power })
	send_event('power_media', { current: current_media_power, last: last_media_power })
	send_event('power_kitchen', { current: current_kitchen_power, last: last_kitchen_power })


end