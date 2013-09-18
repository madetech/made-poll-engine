module Poll
  module Field
    class Option < ActiveRecord::Base
      attr_accessible :label,
                      :order

      default_scope   :order => '`order` ASC'

      def to_s
        label
      end
    end
  end
end
