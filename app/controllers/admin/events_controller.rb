class Admin::EventsController < Admin::ResourceController
  update.after :update_after
  create.after :create_after
  create.before :create_before

	def index
    respond_with(@event) do |wants|
      wants.html { render :action => :index }
      wants.json { render :json => @collection.to_json() }
    end
  end

  def update
    respond_with(@event) do |wants|
      wants.html { redirect_to edit_admin_event_url(Event.find(@event.id)) }
    end
  end

  def create
    respond_with(@event) do |wants|
      wants.html { redirect_to collection_url }
    end
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

    def update_after
      Rails.cache.delete('events')
    end

    def create_after
      Rails.cache.delete('events')
    end

    def create_before
      return unless Spree::Config[:event_status_default]
      @event.is_active = Spree::Config[:event_status_default]
    end

end
