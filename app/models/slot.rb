class Slot < Sequel::Model
  ###########
  # Constants
  ###########

  TYPES = %w[AA AAA].freeze

  #########
  # Plugins
  #########

  plugin :validation_helpers
  plugin :translated_validation_messages
  plugin :defaults_setter

  ##############
  # Associations
  ##############

  many_to_one :item
  many_to_one :battery

  ###############
  # Class methods
  ###############

  class << self
    def new_with_defaults(item)
      new(
        item_id: item.id,
        type:    item.slots.last&.type
      )
    end
  end

  #############
  # Validations
  #############

  def validate
    super

    validates_presence %i[
      item_id
      type
    ]

    validates_includes TYPES, :type

    errors.add(:type, I18n.t('sequel.errors.invalid')) if battery_id && battery.type != type
  end

  #########################
  # Public instance methods
  #########################

  def aaa?
    type == 'AAA'
  end

  def clear
    battery.update(charged: false)
    update(battery: nil)
  end
end
