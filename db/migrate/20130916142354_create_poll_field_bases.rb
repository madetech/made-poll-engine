class CreatePollFieldBases < ActiveRecord::Migration
  def change
    create_table :poll_bases do |t|
      t.string  :title
      t.boolean :required
      t.integer :order
      t.integer :item_id
      t.string  :type

      t.timestamps
    end

    add_index :poll_bases, :order
  end
end
