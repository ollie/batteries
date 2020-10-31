Sequel.migration do
  change do
    alter_table :items do
      add_column :enabled, TrueClass, null: false, default: true
    end
  end
end
