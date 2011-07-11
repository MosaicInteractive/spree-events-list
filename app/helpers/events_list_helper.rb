module EventsListHelper

  def recent_events_list(limit = Spree::Config[:event_list_recent])
    recent_event = Struct.new(:name, :url, :event_start, :event_end, :venue, :summary)
    Event.publish.find(:all, :limit => limit, :conditions => ["end_event > ?", DateTime.now], :order => 'begin_event').collect { |event| recent_event.new(event.title, "/events/show/#{event.id}", event.begin_event, event.end_event, event.venue, event.summary) }
  end

  def has_recent_events?
    !Event.publish.find(:all).empty?
  end

end
