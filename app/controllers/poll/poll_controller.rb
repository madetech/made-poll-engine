module Poll
  class PollController < Poll::ApplicationController
    layout 'application'
    helper Poll::ApplicationHelper::FormHelper
    before_filter :load_poll

    def show
      @entry = Poll::Entry.new(:item => @poll)
    end

    def new
      create_poll_entry

      if @entry.save
        redirect_to :action => :thanks and return
      end

      render 'show'
    end

    def thanks
    end

    def terms
    end

    private
    def load_poll
      @poll = Poll::Item.find_by_url!(params[:slug])
    end

    def create_poll_entry
      @entry = Poll::Entry.new(params[:entry])
      @entry.item_id = @poll.id
      @entry.ip_address = request.remote_ip

      process_form_fields
    end

    def process_form_fields
      get_field_ids.each do |field_id|
        save_field(field_id.to_s)
      end
    end

    def save_field(field_id)
      return unless params[:entry_fields].has_key?(field_id)

      field = params[:entry_fields][field_id]

      if field.has_key?(:field_value)
        save_flat_field(field_id, field)
      else
        save_option_field(field_id, field)
      end
    end

    def save_flat_field(field_id, field)
      @entry.entry_fields << Poll::EntryField.new(
        :field_value => field[:field_value],
        :field_id => field_id
      )
    end

    def save_option_field(field_id, field)
      field.each do |option|
        if option[1].to_i == 1
          @entry.entry_fields << Poll::EntryField.new(
            :field_value => option[0],
            :field_id => field_id
          )
        end
      end
    end

    def get_field_ids
      @poll.fields.map { |field| field.id }
    end
  end
end
