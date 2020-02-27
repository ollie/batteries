Sequel.migration do
  change do
    create_table :groups do
      primary_key :id

      String :name, size: 255, null: false
      String :type, size: 5, null: false
    end
  end
end
