class Group < Sequel::Model
  #########
  # Plugins
  #########

  plugin :validation_helpers
  plugin :translated_validation_messages

  ##############
  # Associations
  ##############

  one_to_many :batteries, order: :id

  #############
  # Validations
  #############

  def validate
    super

    validates_presence [
      :name,
      :type
    ]

    validates_includes ['AA', 'AAA'], :type
  end
end
