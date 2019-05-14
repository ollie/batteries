Sequel.migration do
  change do
    create_table :batteries do
      primary_key :id
      foreign_key :group_id, :groups, null: false

      String :name, size: 255, null: false
      String :type, size: 5, null: false
      String :color, size: 7, null: false
      Boolean :charged, null: false, default: true
      Boolean :dark, null: false, default: false

      index :group_id
    end
  end
end
