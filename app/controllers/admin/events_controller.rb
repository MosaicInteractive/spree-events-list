class Admin::EventsController < Admin::BaseController
  resource_controller

	index.response do |wants|
    wants.html { render :action => :index }
    wants.json { render :json => @collection.to_json() }
  end

  new_action.response do |wants|
    wants.html { render :action => :new, :layout => false }
  end

  update.response do |wants|
    wants.html { redirect_to edit_admin_event_url(Event.find(@event.id)) }
  end

  update.after do
    Rails.cache.delete('events')
  end

  create.response do |wants|
    wants.html { redirect_to collection_url }
  end

  create.after do
    Rails.cache.delete('events')
  end

	private
    def collection
    
      unless request.xhr?
        @search = Event.search(params[:search])
        @search.order ||= "ascend_by_title"

        @collection = @search.paginate(:page => params[:page])
      else
        @collection = Event.title_contains(params[:q]).all(:include => includes, :limit => 10)
        @collection.uniq!
      end

    end

    def create_before
      return unless Spree::Config[:event_status_default]
      @event.is_active = Spree::Config[:event_status_default]
    end

end
