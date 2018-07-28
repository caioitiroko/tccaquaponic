Rails.application.routes.draw do
  get 'linear_regression/index'
  get 'linear_regression/result'
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  post "api/grow_bed_data", to: 'api#grow_bed_data', as: :add_grow_bed_data
  post "api/grow_bed_datum", to: 'api#grow_bed_datum', as: :add_grow_bed_datum
  get "api/grow_bed/:grow_bed_id/last_datum", to: 'api#last_datum', as: :last_datum_grow_bed

  root to: "admin/dashboard#index"
end
