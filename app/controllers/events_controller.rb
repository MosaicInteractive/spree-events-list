class EventsController < ApplicationController
  def index
    @events = Event.find_visible_by_date(Spree::Config[:events_days_before], Spree::Config[:events_days_after])
  end

  def show
    @event = Event.find(params[:id])
  end

end
