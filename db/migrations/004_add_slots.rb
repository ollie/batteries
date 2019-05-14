Sequel.migration do
  change do
    create_table :slots do
      primary_key :id
      foreign_key :item_id,    :items, null: false, on_delete: :cascade
      foreign_key :battery_id, :batteries

      String :type, size: 5, null: false

      index :item_id
      index :battery_id, unique: true
    end
  end
end
