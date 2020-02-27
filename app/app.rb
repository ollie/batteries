class App < Sinatra::Base
  configure do
    Settings.database
    Settings.setup_i18n
  end

  set :public_folder, Settings.root.join('public')
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

  ###########
  # Interface
  ###########

  get '/' do
    redirect batteries_path
  end

  get Route(batteries: '/batteries') do
    slim :'batteries/index', layout: :'layouts/interface'
  end

  get Route(accept_battery: '/slots/:id/accept/:battery_id') do
    slot    = Slot.with_pk!(params[:id])
    battery = Battery.with_pk!(params[:battery_id])

    slot.update(battery: battery)

    redirect batteries_path
  end

  get Route(clear_slot: '/slots/:id/clear') do
    slot = Slot.with_pk!(params[:id])
    slot.clear
    redirect batteries_path
  end

  get Route(charge_battery: '/batteries/:id/charge') do
    battery = Battery.with_pk!(params[:id])
    battery.charge
    redirect batteries_path
  end

  ########
  # Groups
  ########

  get Route(groups: '/groups') do
    if Group.count.zero?
      redirect new_group_path
    else
      slim :'groups/index'
    end
  end

  get Route(new_group: '/groups/new') do
    slim :'groups/new', locals: {
      group: Group.new
    }
  end

  post '/groups/new' do
    group = Group.new
    group.set_fields(params[:group], %i[name type])

    if group.valid?
      group.save
      redirect groups_path
    else
      slim :'groups/new', locals: {
        group: group
      }
    end
  end

  get Route(edit_group: '/groups/:id/edit') do
    slim :'groups/edit', locals: {
      group: Group.with_pk!(params[:id])
    }
  end

  post '/groups/:id/edit' do
    group = Group.with_pk!(params[:id])
    group.set_fields(params[:group], %i[name type])

    if group.valid?
      group.save
      redirect groups_path
    else
      slim :'groups/edit', locals: {
        group: group
      }
    end
  end

  post Route(delete_group: '/groups/:id/delete') do
    group = Group.with_pk!(params[:id])
    group.destroy
    redirect groups_path
  end

  ###########
  # Batteries
  ###########

  get Route(new_group_battery: '/groups/:group_id/batteries/new') do
    group = Group.with_pk!(params[:group_id])

    slim :'batteries/new', locals: {
      group:   group,
      battery: Battery.new_with_defaults(group)
    }
  end

  post '/groups/:group_id/batteries/new' do
    group   = Group.with_pk!(params[:group_id])
    battery = Battery.new(group_id: group.id)
    battery.set_fields(params[:battery], %i[name type color dark charged])

    if battery.valid?
      battery.save
      if params[:add_another].present?
        redirect new_group_battery_path(group.id)
      else
        redirect edit_group_path(group.id)
      end
    else
      slim :'batteries/new', locals: {
        group:   group,
        battery: battery
      }
    end
  end

  get Route(edit_battery: '/batteries/:id/edit') do
    battery = Battery.with_pk!(params[:id])
    group   = battery.group

    slim :'batteries/edit', locals: {
      group:   group,
      battery: battery
    }
  end

  post '/batteries/:id/edit' do
    battery = Battery.with_pk!(params[:id])
    battery.set_fields(params[:battery], %i[name type color dark charged])

    if battery.valid?
      battery.save
      redirect edit_group_path(battery.group_id)
    else
      slim :'batteries/edit', locals: {
        group:   battery.group,
        battery: battery
      }
    end
  end

  post Route(delete_battery: '/batteries/:id/delete') do
    battery = Battery.with_pk!(params[:id])
    battery.destroy
    redirect edit_group_path(battery.group_id)
  end

  #######
  # Items
  #######

  get Route(items: '/items') do
    if Item.count.zero?
      redirect new_item_path
    else
      slim :'items/index'
    end
  end

  get Route(new_item: '/items/new') do
    slim :'items/new', locals: {
      item: Item.new
    }
  end

  post '/items/new' do
    item = Item.new
    item.set_fields(params[:item], %i[name css_class])

    if item.valid?
      item.save
      redirect edit_item_path(item.id)
    else
      slim :'items/new', locals: {
        item: item
      }
    end
  end

  get Route(edit_item: '/items/:id/edit') do
    slim :'items/edit', locals: {
      item: Item.with_pk!(params[:id])
    }
  end

  post '/items/:id/edit' do
    item = Item.with_pk!(params[:id])
    item.set_fields(params[:item], %i[name css_class])

    if item.valid?
      item.save
      redirect items_path
    else
      slim :'items/edit', locals: {
        item: item
      }
    end
  end

  post Route(delete_item: '/items/:id/delete') do
    item = Item.with_pk!(params[:id])
    item.destroy
    redirect items_path
  end

  #######
  # Slots
  #######

  get Route(new_item_slot: '/items/:item_id/slots/new') do
    item = Item.with_pk!(params[:item_id])

    slim :'slots/new', locals: {
      item: item,
      slot: Slot.new_with_defaults(item)
    }
  end

  post '/items/:item_id/slots/new' do
    item = Item.with_pk!(params[:item_id])
    slot = Slot.new(item_id: item.id)
    slot.set_fields(params[:slot], [:type])

    if slot.valid?
      slot.save
      if params[:add_another].present?
        redirect new_item_slot_path(item.id)
      else
        redirect edit_item_path(item.id)
      end
    else
      slim :'slots/new', locals: {
        item: item,
        slot: slot
      }
    end
  end

  get Route(edit_slot: '/slots/:id/edit') do
    slot = Slot.with_pk!(params[:id])

    slim :'slots/edit', locals: {
      item: slot.item,
      slot: slot
    }
  end

  post '/slots/:id/edit' do
    slot = Slot.with_pk!(params[:id])
    slot.set_fields(params[:slot], [:type])

    if slot.valid?
      slot.save
      redirect edit_item_path(slot.item_id)
    else
      slim :'slots/edit', locals: {
        item: slot.item,
        slot: slot
      }
    end
  end

  post Route(delete_slot: '/slots/:id/delete') do
    slot = Slot.with_pk!(params[:id])
    slot.destroy
    redirect edit_item_path(slot.item_id)
  end
end
