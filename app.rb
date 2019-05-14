class App < Sinatra::Base
  configure do
    Settings.database
    Settings.setup_i18n
    Settings.load_files('lib/**')
    Settings.load_files('models/**')
  end

  set :slim, layout: :'layouts/application',
             pretty: true
  set :sessions, expire_after: 14.days
  set :session_secret, Settings.secrets.session_secret

  register Sinatra::Routing
  helpers Sinatra::CommonHelpers
  helpers Sinatra::AppHelpers

  #######
  # Hooks
  #######

  before do
    pass if request.path == new_session_path
    pass if Login.valid?(session[:encrypted_username], session[:encrypted_password])

    redirect new_session_path
  end

  ##########
  # Sessions
  ##########

  get Route(new_session: '/sessions/new') do
    slim :'sessions/new', layout: :'layouts/sessions'
  end

  post '/sessions/new' do
    encrypted_username = Login.encrypt_username(params[:username])
    encrypted_password = Login.encrypt_password(params[:password])

    if Login.valid?(encrypted_username, encrypted_password)
      session[:encrypted_username] = encrypted_username
      session[:encrypted_password] = encrypted_password

      redirect batteries_path
    else
      slim :'sessions/new', layout: :'layouts/sessions', locals: {
        login_failed: true
      }
    end
  end

  #################
  # Service Entries
  #################

  get '/' do
    redirect batteries_path
  end

  get Route(batteries: '/batteries') do
    slim :'batteries/index'
  end

  get Route(accept_battery: '/slots/:id/accept/:battery_id') do
    slot    = Slot.with_pk!(params[:id])
    battery = Battery.with_pk!(params[:battery_id])

    slot.update(battery: battery)

    redirect batteries_path
  end

  get Route(clear_slot: '/slots/:id/clear') do
    slot = Slot.with_pk!(params[:id])
    slot.update(battery: nil)
    redirect batteries_path
  end
end
