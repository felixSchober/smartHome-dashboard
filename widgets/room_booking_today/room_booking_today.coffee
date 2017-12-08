class Dashing.RoomBookingToday extends Dashing.Widget

  onData: (data) =>
    event = rest = null
    getEvents = (first, others...) ->
      console.log first
      event = first
      rest = others

    getEvents data.events.items...

    start = moment(event.start)
    end = moment(event.end)

    # duration of current/next event
    duration = moment.duration(end.diff(start))
    duration_minutes = duration.asMinutes()

    @set('event',event)
    @set('event_date', start.format('dddd Do MMMM'))
    @set('event_times', start.format('HH:mm') + " - " + end.format('HH:mm'))
    @set('event_times_duration', duration_minutes)
    @set('event_organizer', 'Organizer: ' + event.creator)
    @set('today_name', moment().format('dddd'))

    # get current time
    now = new Date
    start_date = new Date(event.start)

    # if booking is running the start time is less than the current time.
    next_booking_text = ''
    console.trace(now)
    if now.getTime() > start_date.getTime()
      # use current booking 'ends in' endTime
      next_booking_text = 'Current booking ends in ' + end.fromNow()
    else
      next_booking_text = 'Next booking starts in ' + start.fromNow()

    @set('next_booking_text', next_booking_text)

    next_events = []
    for next_event in rest
      start = moment(next_event.start)
      start_date = start.format('dddd')
      start_time = start.format('HH:mm')
      start_time_in = start.fromNow()

      # Do not show end of day envent here
      if next_event.summary isnt 'END OF DAY'
        next_events.push { summary: next_event.summary, start_date: start_date, start_time: start_time, start_time_in: start_time_in }
    @set('next_events', next_events)