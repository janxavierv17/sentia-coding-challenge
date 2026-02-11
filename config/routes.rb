Rails.application.routes.draw do
  resources :people, only: [:index] do
    collection do
      post :import
    end
  end

  root "people#index"
end
