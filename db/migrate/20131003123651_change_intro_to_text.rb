class ChangeIntroToText < ActiveRecord::Migration
  def up
    change_column :poll_items, :intro, :text
  end

  def down
    change_column :poll_items, :intro, :string
  end
end
