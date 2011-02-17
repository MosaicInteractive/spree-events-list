# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EventsListExtension < Spree::Extension
  version "0.1"
  description "Events list for sidebar content"
  url "http://github.com/azimuth/spree-events-list"

  # Please use events_list/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem "tiny_mce"
  end

  
  def activate

    #Spree::Config.set(:event_list_recent => 3)

    # make your helper avaliable in all views
    Spree::BaseController.class_eval do
      helper EventsListHelper
    end

    AppConfiguration.class_eval do
      preference :event_status_default, :integer, :default => 1
      preference :event_list_recent, :integer, :default => 3
    end

  end
end
