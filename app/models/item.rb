class Item < Sequel::Model
  #########
  # Plugins
  #########

  plugin :validation_helpers
  plugin :translated_validation_messages

  ##############
  # Associations
  ##############

  one_to_many :slots, order: :id

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
      :name
    ]
  end
end
