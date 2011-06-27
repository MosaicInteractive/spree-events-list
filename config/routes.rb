Rails.application.routes.draw do
  namespace :admin do
    resources :events
		resources :events_settings
  end
  
  match "/events" => "events#index"
  match '/events/show/:id' => "events#show"
  
end
