module Poll
  module Field
    class Base < ActiveRecord::Base
      attr_accessible   :title,
                        :required,
                        :order,
                        :type

      default_scope     :order => '`order` ASC'

      def multiple?
        false
      end

      def template
        type.downcase!.demodulize
      end

      def to_s
        title
      end
    end
  end
end
