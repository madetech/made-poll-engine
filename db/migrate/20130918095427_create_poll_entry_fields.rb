class CreatePollEntryFields < ActiveRecord::Migration
  def change
    create_table :poll_entry_fields do |t|
      t.integer :entry_id
      t.integer :field_id
      t.string  :field_value

      t.timestamps
    end

    add_index :poll_entry_fields, :entry_id
    add_index :poll_entry_fields, :field_id
  end
end
