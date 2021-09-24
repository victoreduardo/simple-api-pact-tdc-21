Rails.application.routes.draw do
  resources :metrics, only: %i[index create]

  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'
end
