class AddActiveToPollItem < ActiveRecord::Migration
  def change
    add_column :poll_items, :active, :boolean, :default => true
  end
end
