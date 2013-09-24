if defined?(ActiveAdmin)
  ActiveAdmin.register Poll::Item do
    controller do
      cache_sweeper Poll.config.cache_sweeper if Poll.config.cache_sweeper
      defaults      :finder => :find_by_url
    end

    action_item :only => :show do
      link_to "View Poll on site", poll_path(poll_item.url)
    end

    menu :label => 'Polls'

    index do
      column :title
      column :created_at
      column :updated_at

      default_actions
    end

    filter :title

    form do |f|
      f.inputs "Poll" do
        f.input :title,         :wrapper_html => { :class => "default" }

        f.input :intro,         :wrapper_html => { :class => "default" },
                                :as => :rich,
                                :config => { :width => '76%', :height => '400px' }

        f.input :image,         :wrapper_html => { :class => "default" },
                                :as => :file,
                                :hint => f.template.image_tag(f.object.image.url(:thumb))

        f.input :active
      end

      f.inputs "Text Fields" do
        f.has_many :text_fields do |field|
          field.input :title
          field.input :order
          field.input :required
          field.input :_destroy, :as => :boolean, :label => "Delete"
        end
      end

      option_fields = [
        ['Checkbox',  :checkbox_fields],
        ['Select',    :select_fields]
      ]

      option_fields.each do |field|
        f.inputs field[0] do
          f.has_many field[1] do |f_field|
            f_field.input :title
            f_field.input :order
            f_field.input :required
            f_field.input :_destroy, :as => :boolean, :label => "Delete"

            f_field.has_many :options do |option|
              option.input :label
              option.input :order

              option.input :_destroy, :as => :boolean, :label => "Delete"
            end
          end
        end
      end

      f.inputs "Thanks Page" do
        f.input :thanks_title,  :wrapper_html => { :class => "default" }

        f.input :thanks_page,   :wrapper_html => { :class => "default" },
                                :as => :rich,
                                :config => { :width => '76%', :height => '400px' }
      end

      f.inputs "Terms and Conditions" do
        f.input :terms_and_conditions,  :wrapper_html => { :class => "default" },
                                        :as => :rich,
                                        :config => { :width => '76%', :height => '400px' }
      end

      f.actions
    end

    action_item :only => :show do
      link_to "Download Entries", entries_admin_poll_item_path(params[:id], :format => :csv)
    end

    member_action :entries do
      respond_to do |format|
        format.csv { render text: Poll::Item.find_by_url(params[:id]).export_entries_csv }
      end
    end
  end
end
