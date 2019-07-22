class Group < Sequel::Model
  ###########
  # Constants
  ###########

  TYPES = %w[AA AAA].freeze

  #########
  # Plugins
  #########

  plugin :validation_helpers
  plugin :translated_validation_messages

  ##############
  # Associations
  ##############

  one_to_many :batteries, order: :id

  #################
  # Dataset methods
  #################

  dataset_module do
    def ordered
      order(:id)
    end
  end

  #############
  # Validations
  #############

  def validate
    super

    validates_presence [
      :name,
      :type
    ]

    validates_includes TYPES, :type
  end

  #########################
  # Public instance methods
  #########################

  def full_name
    "#{name} #{type}"
  end
end
