module Poll
  class EntryField < ActiveRecord::Base
    attr_accessible               :field_id,
                                  :field_value

    belongs_to                    :item_entry
  end
end
