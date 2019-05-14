Sequel.migration do
  change do
    create_table :items do
      primary_key :id

      String :name, size: 255, null: false
      String :css_class, size: 255
    end
  end
end
