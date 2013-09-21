module Poll
  class Item < ActiveRecord::Base
    attr_accessible               :title,
                                  :intro,
                                  :image,
                                  :active,
                                  :thanks_title,
                                  :thanks_page,
                                  :terms_and_conditions,
                                  :fields_attributes,
                                  :text_fields_attributes,
                                  :select_fields_attributes,
                                  :checkbox_fields_attributes

    has_many                      :fields,          :foreign_key => 'item_id', :class_name => 'Field::Base'
    has_many                      :text_fields,     :foreign_key => 'item_id', :class_name => 'Field::Text'
    has_many                      :select_fields,   :foreign_key => 'item_id', :class_name => 'Field::Select'
    has_many                      :checkbox_fields, :foreign_key => 'item_id', :class_name => 'Field::Checkbox'
    has_many                      :entries,         :foreign_key => 'item_id', :class_name => 'Entry'

    accepts_nested_attributes_for :fields,          :allow_destroy => true
    accepts_nested_attributes_for :text_fields,     :allow_destroy => true
    accepts_nested_attributes_for :select_fields,   :allow_destroy => true
    accepts_nested_attributes_for :checkbox_fields, :allow_destroy => true

    has_attached_file             :image, :styles => Poll.config.image_styles

    acts_as_url                   :title

    def terms_and_conditions_required?
      not terms_and_conditions.nil? and terms_and_conditions.length > 0
    end

    def to_param
      url
    end

    def to_s
      title
    end
  end
end
