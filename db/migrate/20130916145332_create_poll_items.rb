class CreatePollItems < ActiveRecord::Migration
  def change
    create_table :poll_items do |t|
      t.string :title
      t.string :url
      t.string :intro
      t.string :thanks_title
      t.text   :thanks_page
      t.text   :terms_and_conditions

      t.timestamps
    end

    add_attachment :poll_items, :image
    add_index :poll_items, :url
  end
end
