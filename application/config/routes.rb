require 'sidekiq/web'

Rails.application.routes.draw do


  get 'user/index'

  get 'user/new'

  get 'user/create'


  mount Sidekiq::Web => '/sidekiq'

  scope "/admin" do
    resources :users
  end

  root 'events#index'

  resources :events
  resources :settings do
    member do
      put :aktifasi
      patch :customtext
    end
    collection do
      get :reset
      get :resetundian
      get :allpresence
      get :output
      get :resetlogabsensi
      get :resetlogmoving
    end
  end
  #resources :displays
  resources :type_of_events do
    collection{
      get :getalldata, :defaults => {:format => 'json'}
      get :search_person
    }
  end

  resources :guests do
   	collection {
    post :import
    get :edit
    get :presence
    get :transfer
    get :gift
    get :print_qr
    get :print_no_undian
   	}
   end

   resources :scanners do
    collection{
      get :checkin
      get :checkout
      get :testscan
    }
   end
    
  resources :weddings do
    collection{
      get :update_presence
      get :printulang
      get :reprint
      get :update_souvenir
      get :print
      get :print_qr
      get :print_qr_master
      get :template_qr
      get :template_qr_master
      get :report_wedding
      get :souvenir
      get :export_excel
      get :print_qr_page
      get :report
      get :dashboard
      get :dashboard_vip
      get :search
      post :import
      # mobile
      get :getalldata, :defaults => {:format => 'json'}
      get :kehadiranmobile
      get :update_presence_mobile, :defaults => {:format => 'json'}
      get :update_souvenir_mobile, :defaults => {:format => 'json'}
      get :souvenirmobile
      #fix
      get :master
      get :masterdata
      get :edit
      get :dashboard_count
      #new camera qrcode
      get :qr_checkin
      get :qr_checkin2
      get :newqr
      patch :update_guest_brought_api, :defaults => {:format => 'json'}
      #update reset_presence_souvenir
      patch :reset_presence_souvenir
      # get :reset_presence_souvenir_info
    }
  end

  resources :gatherings do
    collection{
      post :import
      get :update_presence
      get :printulang
      get :reprint
      get :update_souvenir
      get :print
      get :print_qr
      get :print_qr_master
      get :template_qr
      get :template_qr_master
      get :souvenir
      get :export_excel
      get :print_qr_page
      get :report
      get :dashboard
      get :search
      get :pengaturan
      get :reset
      #mobile
      get :kehadiranmobile
      get :update_presence_mobile, :defaults => {:format => 'json'}
      get :update_souvenir_mobile, :defaults => {:format => 'json'}
      get :souvenirmobile
      #fix
      get :master
      get :masterdata
      get :edit
      patch :update_guest_brought_api, :defaults => {:format => 'json'}
    }
  end

  resources :concerts do
    collection{
      get :update_presence
      get :printulang
      get :reprint
      get :update_souvenir
      get :print
      get :print_qr
      get :print_qr_master
      get :template_qr
      get :template_qr_master
      get :report_wedding
      get :souvenir
      get :export_excel
      get :print_qr_page
      get :report
      get :dashboard
      get :search
      post :import
      #mobile
      get :kehadiranmobile
      get :update_presence_mobile, :defaults => {:format => 'json'}
      get :update_souvenir_mobile, :defaults => {:format => 'json'}
      get :souvenirmobile
      #fix
      get :master
      get :masterdata
      get :edit
    }
  end

   resources :absensis do
     collection{
       get :update_presence
       get :printulang
       get :reprint
       get :update_souvenir
       get :print
       get :print_qr
       get :print_qr_master
       get :template_qr
       get :template_qr_master
       get :report_wedding
       get :souvenir
       get :export_excel
       get :print_qr_page
       get :report
       get :dashboard
       get :search
       post :import
       #mobile
       get :kehadiranmobile
       get :update_presence_mobile, :defaults => {:format => 'json'}
       get :update_souvenir_mobile, :defaults => {:format => 'json'}
       get :souvenirmobile
       #fix
       get :master
       get :masterdata
       get :edit
       get :detail
       get :clientview
     }
   end

   resources :movings do
     collection{
       get :update_presence
       get :printulang
       get :reprint
       get :update_souvenir
       get :print
       get :print_qr
       get :print_qr_master
       get :template_qr
       get :template_qr_master
       get :report_wedding
       get :souvenir
       get :export_excel
       get :print_qr_page
       get :report
       get :dashboard
       get :search
       post :import
       #mobile
       get :kehadiranmobile
       get :update_presence_mobile, :defaults => {:format => 'json'}
       get :update_souvenir_mobile, :defaults => {:format => 'json'}
       get :souvenirmobile
       #fix
       get :master
       get :masterdata
       get :edit
       get :detail
       get :clientview
       #kelas in
       get :class2
       get :class3
       get :class4
       get :class5
       get :class6
       get :class7
       get :class8
       get :class9
       get :class10
       #kelas out
       get :souvenir2
       get :souvenir3
       get :souvenir4
       get :souvenir5
       get :souvenir6
       get :souvenir7
       get :souvenir8
       get :souvenir9
       get :souvenir10
     }
   end

  resources :posts

  resources :undians do
    collection{
      get :winner
      get :thechoosen
    }
  end



  get '/dashboards/coming_soon', to: 'dashboards#coming_soon'
  get '/dashboards', to: 'dashboards#index'

end
