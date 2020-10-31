class Item < Sequel::Model
  #########
  # Plugins
  #########

  plugin :validation_helpers
  plugin :translated_validation_messages
  plugin :defaults_setter

  ##############
  # Associations
  ##############

  one_to_many :slots, order: :id

  #################
  # Dataset methods
  #################

  dataset_module do
    def enabled
      where(enabled: true)
    end

    def ordered
      select(Sequel[:items].*, Sequel.~(Sequel[:slots][:id] => nil).as(:has_batteries)).left_join(:slots, item_id: :id) do |j, lj, js|
        Sequel.~(Sequel[:slots][:battery_id] => nil)
      end.group(Sequel[:items][:id], :has_batteries).order(Sequel.desc(:has_batteries), :name)
    end
  end

  #############
  # Validations
  #############

  def validate
    super

    validates_presence [
      :name
    ]
  end
end
