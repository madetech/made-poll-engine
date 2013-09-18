module Poll
  module Field
    class Checkbox < Base
      attr_accessible :options_attributes

      has_many  :options, :foreign_key => 'field_id'

      accepts_nested_attributes_for :options, :allow_destroy => true
    end
  end
end
