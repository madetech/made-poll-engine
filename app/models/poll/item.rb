require 'csv'

module Poll
  class Item < ActiveRecord::Base
    EXPORT_IGNORED_FIELDS =       [:item, :updated_at]

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

    def export_entries_csv
      # We (very unfortunately) need to drop out of AR at this point for performance reasons.
      results = execute_csv_export

      CSV.generate do |csv|
        csv << get_csv_header

        # MySQL returns a resultset, SQLite returns an array of hashes
        if results.kind_of?(Array)
          results.each do |row|
            csv << strip_integer_keys(row).values
          end
        else
          results.each(:as => :array) do |row|
            csv << row
          end
        end
      end
    end

    private
    def execute_csv_export
      ActiveRecord::Base.connection.execute(get_export_sql)
    end

    def strip_integer_keys(row)
      row.reject { |k,v| k.is_a? Integer }
    end

    def get_export_sql
      columns = get_export_columns_sql

      """
        SELECT #{columns} #{get_fields_sql} FROM `#{Poll::Entry.table_name}`
        #{get_field_aliases_sql}
        WHERE `#{Poll::Entry.table_name}`.`item_id` = #{self.id}
        GROUP BY `#{Poll::Entry.table_name}`.id
      """
    end

    def get_export_columns_sql
      sql = ""
      after = ", "
      column_headers = get_column_headers
      column_headers.each_with_index do |col, index|
        after = "" if index+1 == column_headers.length
        sql.concat("`#{Poll::Entry.table_name}`.#{col}#{after}")
      end

      sql
    end

    def get_csv_header
      csv_header = []
      field_column_headers = get_field_column_headers

      csv_header.concat(get_column_headers_human)
      csv_header.concat(field_column_headers) if field_column_headers.length > 0

      csv_header
    end

    def get_column_headers
      return [] if self.entries.length < 1

      column_headers = []
      entry_class = entries.first.class.name.constantize
      entry_class.column_names.each do |col|
        column_headers << col unless EXPORT_IGNORED_FIELDS.include?(col.to_sym)
      end

      column_headers
    end

    def get_column_headers_human
      get_column_headers.map { |col| col.humanize }
    end

    def get_field_column_headers
      fields.map { |field| get_headers_from_field(field) }.flatten
    end

    def get_headers_from_field(field)
      if field.multiple?
        return field.options.map { |option| "#{field.title}: #{option.label}" }
      else
        return field.title
      end
    end

    def get_fields_sql
      sql = fields.map do |field|
        if field.multiple?
          get_field_multiple_sql(field)
        else
          get_field_single_sql(field)
        end
      end

      sql.join
    end

    def get_field_multiple_sql(field)
      option_fields = field.options.map do |option|
        ", `field_#{field.id}_#{option.id}`.field_value AS `field_#{field.id}_#{option.id}_f`"
      end

      option_fields.join
    end

    def get_field_single_sql(field)
      ", `field_#{field.id}`.field_value AS `field_#{field.id}_f`"
    end

    def get_field_aliases_sql
      sql = fields.map do |field|
        if field.multiple?
          get_multiple_field_aliases_sql(field)
        else
          get_single_field_aliases_sql("field_#{field.id}", field.id)
        end
      end

      sql.join
    end

    def get_multiple_field_aliases_sql(field)
      sql = field.options.map do |option|
        """
          #{get_single_field_aliases_sql("field_#{field.id}_#{option.id}", field.id)}
          AND `field_#{field.id}_#{option.id}`.`field_value` = #{option.id}
        """
      end

      sql.join
    end

    def get_single_field_aliases_sql(field_name, field_id)
      """
        LEFT JOIN `#{Poll::EntryField.table_name}` AS #{field_name} ON
        `#{field_name}`.`entry_id` = `#{Poll::Entry.table_name}`.`id`
        AND `#{field_name}`.`field_id` = #{field_id}
      """
    end
  end
end
