class CreatePollFieldOptions < ActiveRecord::Migration
  def change
    create_table :poll_options do |t|
      t.string  :label
      t.integer :field_id
      t.integer :order

      t.timestamps
    end

    add_index :poll_options, :order
  end
end
