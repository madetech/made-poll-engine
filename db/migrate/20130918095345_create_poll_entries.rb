class CreatePollEntries < ActiveRecord::Migration
  def change
    create_table :poll_entries do |t|
      t.integer :item_id
      t.string  :ip_address

      t.timestamps
    end

    add_index :poll_entries, :item_id
  end
end
