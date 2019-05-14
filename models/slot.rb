class Slot < Sequel::Model
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

  #############
  # Validations
  #############

  def validate
    super

    validates_presence [
      :item_id,
      :type
    ]

    validates_includes ['AA', 'AAA'], :type

    errors.add(:battery_id, :invalid) if battery_id && battery.type != type
  end

  #########################
  # Public instance methods
  #########################

  def aaa?
    type == 'AAA'
  end
end
