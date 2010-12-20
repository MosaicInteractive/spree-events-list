class Admin::EventsController < Admin::BaseController
  resource_controller
  uses_tiny_mce :only => [:new, :create, :edit, :update, :index], :options => {
      :editor_selector                 => 'fullwidth mceEditor',
      :theme                           => 'advanced',
      :theme_advanced_toolbar_location => 'top',
      :theme_advanced_toolbar_align    => 'left',
      :theme_advanced_buttons1         => 'bold,italic,underline,strikethrough,justifyleft,justifycenter,justifyright,justifyfull,separator,styleselect,formatselect,fontselect,fontsizeselect,removeformat,forecolor,backcolor',
      :theme_advanced_buttons2         => 'cut,copy,paste,pasteword,separator,search,replace,separator,bullist,numlist,outdent,indent,blockquote,separator,undo,redo,separator,link,unlink,anchor,image,media,code,separator,preview',
      :theme_advanced_buttons3         => 'tablecontrols,separator,hr,separator,sub,sup,separator,charmap,separator,print,fullscreen',
      :plugins                         => %w{ table fullscreen paste searchreplace advlink advimage preview  print }
    }

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

end
