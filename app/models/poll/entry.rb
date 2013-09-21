module Poll
  class Entry < ActiveRecord::Base
    attr_accessible               :item,
                                  :ip_address,
                                  :entry_fields_attributes,
                                  :agree_terms

    belongs_to                    :item

    has_many                      :entry_fields,    :foreign_key => 'entry_id', :class_name => 'EntryField'

    accepts_nested_attributes_for :entry_fields,    :allow_destroy => true

    validate                      :validate
    validates_acceptance_of       :agree_terms,     :allow_nil => false,
                                                    :message => I18n.t('poll.accept_terms'),
                                                    if: :terms_and_conditions_required?

    def terms_and_conditions_required?
      item.terms_and_conditions_required?
    end

    def validate
      item.fields.each do |field|
        check_mandatory_field(field) if field.required
      end
    end

    def check_mandatory_field(field)
      if blank_field_ids.include?(field.id) or not all_field_ids.include?(field.id)
        errors.add(field.title, I18n.t('poll.field_missing'))
      end
    end

    def blank_field_ids
      blank_fields.map { |entry_field| entry_field.field_id }
    end

    def blank_fields
      entry_fields.select { |entry_field| entry_field.field_value.length < 1 }
    end

    def all_field_ids
      entry_fields.map { |entry_field| entry_field.field_id }
    end
  end
end
