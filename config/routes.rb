RubyTester::Application.routes.draw do
  root :to => 'home#index'

  resources :tests, except: :show do
    resources :questions
    resources :sessions, controller: :test_sessions, only: [:new, :create, :destroy, :index] do
      delete 'inactive', action: 'destroy_inactive', on: :collection
    end
    collection do
      get 'archived'
    end
    member do
      post 'archive'
      scope 'tags' do
        post 'create', action: :add_tag, as: :add_tag
        delete 'destroy/:tag', action: :remove_tag, as: :remove_tag
      end
    end
  end

  controller 'test_sessions' do
    get 'start'
    get 'results'
    get 'end'
  end

  scope 'sessions' do
    get ':id/register' => 'test_sessions#register', as: :session_register
    post ':id/assign_student/:student_id' => 'test_sessions#assign_student', as: :assign_student
    post ':id/check_question' => 'test_sessions#check_question', as: :check_question
    get ':id/watch' => 'test_sessions#watch', as: :session_watch
    get ':id/full-report' => 'test_sessions#full_report', as: :session_full_report
    get ':id/report/:student_id' => 'test_sessions#report', as: :session_report
    get ':id/q-report/:student_id' => 'test_sessions#questions_status', as: :session_questions_status
    get ':id/status' => 'test_sessions#status', as: :session_status
  end

  resources :reports
  resources :groups do
    resources :students
  end

  controller :user_sessions do
    match 'login' => :login, via: [:get, :post]
    get 'logout' => :logout
    get 'profile' => :profile
  end

  namespace :admin do
    get "/" => "admin#index"
    get 'maintenance' => 'maintenance#index'
    post 'maintenance/rebuild_tag_index'
    resources :users
  end

  get 'tests/tags' => 'tests#tags', as: :tests_tags
  get 'tests/tagged/:tag' => 'tests#index', constraints: { tag: /[^\/]+/ }, as: :test_tags
  
end