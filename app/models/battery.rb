class Battery < Sequel::Model
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

  many_to_one :group
  one_to_one :slot

  ###############
  # Class methods
  ###############

  class << self
    def new_with_defaults(group)
      new(
        group_id: group.id,
        name: "#{group.name} #{group.batteries.count + 1}",
        type: group.type,
        color: group.batteries.last&.color
      )
    end
  end

  #############
  # Validations
  #############

  def validate
    super

    validates_presence [
      :group_id,
      :name,
      :color
    ]

    validates_includes TYPES, :type

    errors.add(:type, I18n.t('sequel.errors.invalid')) if group_id && group.type != type
  end

  #########################
  # Public instance methods
  #########################

  def aaa?
    type == 'AAA'
  end

  def charge
    update(charged: true)
  end
end
