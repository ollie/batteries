class Battery < Sequel::Model
  #########
  # Plugins
  #########

  plugin :validation_helpers
  plugin :translated_validation_messages
  plugin :defaults_setter

  ##############
  # Associations
  ##############

  many_to_one :group
  one_to_one :slot

  #############
  # Validations
  #############

  def validate
    super

    validates_presence [
      :group_id,
      :color
    ]

    errors.add(:group_id, :invalid) if group_id && group.type != type
  end

  #########################
  # Public instance methods
  #########################

  def aaa?
    type == 'AAA'
  end
end
