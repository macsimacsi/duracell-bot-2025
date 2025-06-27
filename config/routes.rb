Rails.application.routes.draw do
  scope :admin do
    resources :states
    resources :conversations
    resources :codes
    resources :participants, except: %i[new]
    resources :participations
    resources :admins
    resources :api_calls
    resources :roles
    resources :winners
    resources :prizes
    resources :whatsapp_campaigns, only: %i[index], as: 'enviar_mensajes'
    get 'whatsapp_campaigns_data', to: 'whatsapp_campaigns#whatsapp_campaigns_data'
    root to: 'dashboard#index'
    get 'dashboard' => 'dashboard#dashboard', as: 'dashboard'
    post 'sorteo' => 'winners#sorteo', as: 'sorteo_winner_post'
    get 'sorteo' => 'winners#sorteo', as: 'sorteo_winner'
    get 'sorteo_config' => 'winners#sorteo_config', as: 'sorteo_config'
    get 'sorteo_count', to: 'winners#sorteo_count'
  end

  devise_for :admins, skip: %i[registrations passwords]

  scope :whatsapp do
    get 'webhook' => 'whatsapp#webhook'
    post 'webhook' => 'whatsapp#webhook'

    post 'whatsapp_campaigns', to: 'whatsapp_campaigns#create', as: 'whatsapp_campaigns'
  end

  root to: 'site#index', as: 'site_index'

  get 'check_winner' => 'winners#check', as: 'check_winner'
  post 'check_winner' => 'winners#check', as: 'check_winner_post'
  get 'confirm_winner/:id' => 'winners#confirm', as: 'confirm_winner'
  get 'draw_winner' => 'winners#draw', as: 'draw_winner'
  post 'draw_winner' => 'winners#draw', as: 'draw_winner_post'
  patch 'admin/sort' => 'admins#sort', as: 'admin_sort'
  get 'participation/:new_status/:id' => 'participations#change_status', as: 'participation_approve'
end
