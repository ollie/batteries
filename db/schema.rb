Sequel.migration do
  change do
    create_table(:groups) do
      primary_key :id
      column :name, 'character varying(255)', null: false
      column :type, 'character varying(5)', null: false
    end

    create_table(:items) do
      primary_key :id
      column :name, 'character varying(255)', null: false
      column :css_class, 'character varying(255)'
      column :enabled, 'boolean', default: true, null: false
    end

    create_table(:schema_info) do
      column :version, 'integer', default: 0, null: false
    end

    create_table(:batteries) do
      primary_key :id
      foreign_key :group_id, :groups, null: false, key: [:id]
      column :name, 'character varying(255)', null: false
      column :type, 'character varying(5)', null: false
      column :color, 'character varying(7)', null: false
      column :charged, 'boolean', default: true, null: false
      column :dark, 'boolean', default: false, null: false

      index [:group_id]
    end

    create_table(:slots) do
      primary_key :id
      foreign_key :item_id, :items, null: false, key: [:id], on_delete: :cascade
      foreign_key :battery_id, :batteries, key: [:id]
      column :type, 'character varying(5)', null: false

      index [:battery_id], unique: true
      index [:item_id]
    end
  end
end
