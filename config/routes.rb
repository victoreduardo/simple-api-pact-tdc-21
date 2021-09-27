Rails.application.routes.draw do
  resources :metrics, only: %i[index create]
end
