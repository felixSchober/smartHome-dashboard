def get_current_total_power(http)
	request = create_request("/api/hs110/plugs/powerState")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['power'].to_i
 end

 def get_espresso_graph(http)
	request = create_request("/api/hs110/plugs/Espresso/powerState/history")
  	response = http.request(request)
 	data = JSON.parse(response.body)
 	return data['history']
 end

# single items
current_total_power_level = 0.0

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

total_power_chart_titles = ['Espresso Machine']

total_power_chart_data = [
	{
		label: total_power_chart_titles[0],
		data: Array.new(power_chart_labels.length) { 0 },
		backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * power_chart_labels.length,
    	borderColor: [ 'rgba(255, 99, 132, 1)' ] * power_chart_labels.length,
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
	espresso_power_data = get_espresso_graph(http)
	total_power_chart_data[0][:data] = espresso_power_data
	send_event('total_electricity_consumption_graph', { labels: power_chart_labels, datasets: total_power_chart_data, options: charts_options })


	send_event('electricityTotalCurrent', { current: current_total_power_level, last: last_total_power_level })
end