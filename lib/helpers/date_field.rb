module ActionView
  module Helpers
    module FormHelper
      def date_field(object_name, method, options = {})
        obj = ::ActionView::Helpers::InstanceTag.new(object_name, method, self).object
        format = (options[:only_date] ? :date : :long)
        text_field(object_name, method, options.merge(:value => ((v=obj.try(method)).blank? ? options[:value] : v.try(:to_s,format)), :onclick=>date_onclick(options)))
      end

      def date_field_tag(name, value =nil, options= {})
        text_field_tag(name, value, options.merge(:onclick=>date_onclick(options)))
      end

      def rich_text_area(object_name, method, options = {})
        rich_editor_files +
          text_area(object_name, method, options.merge({:id => "fancypants"}))
      end
      
      def rich_text_area_tag(name, content = nil, options = {})
        rich_editor_files +
          text_area_tag(name, content, options.merge({:id => "fancypants"}))
      end

      private
      def date_onclick(options={})
        "SelectDate(this,'yyyy-MM-dd',#{I18n.locale.to_s=="zh" ? 0 : 1}, #{options[:only_date] ? 0 : 1}, #{options[:begin]||1}, #{options[:end]||1})"
      end
    end

    class FormBuilder #:nodoc:
      def date_field(method, options = {})
        @template.date_field(@object_name, method, objectify_options(options))
      end

      def rich_text_area(method, options = {})
        @template.rich_text_area(@object_name, method, objectify_options(options))
      end
    end
  end
end

=begin
module ActionView
  module Helpers
    module FormHelper
      def date_field(object_name, method, options = {})
        obj = ::ActionView::Helpers::InstanceTag.new(object_name, method, self).object
        date_picker_options = options.extract!(:change, :format, :range)
        value = ((v=obj.try(method)).blank? ? options[:value] : v.try(:to_s,:date))

        text_field(object_name, method, options.merge(:value => value)) +
          date_picker("#{object_name}_#{method}", value, date_picker_options)
      end

      def date_field_tag(name, value =nil, options= {})
        id = sanitize_to_id(name).gsub(".", "_")
        @id_list ||= []
        @id_list << (@id_list.include?(id) ? (id = "#{id}_dup") : id)
        date_picker_options = options.extract!(:change, :format, :range)

        text_field_tag(name, value, options.merge!(:id => id)) + date_picker(id, value, date_picker_options)
      end

      private
      def date_picker(dom_id, value, options = {})
        locale = ({"en" => "en-GB", "zh" => "zh-CN"}[I18n.locale.to_s] || I18n.locale)
        dom_id = sanitize_to_id(dom_id)
        range = options[:range] || [-10, 10]
        
        jquery_include_tag(:ui, :css, :i18n) +
          javascript_tag do
          "$(function() {
              $('##{dom_id}').datepicker(#{options[:change] ? "{changeYear: true, changeMonth: true}" : ""});
              $('##{dom_id}').datepicker('option', $.datepicker.regional['#{locale}']);
              $('##{dom_id}').datepicker('option', 'dateFormat', '#{options[:format]||"yy-mm-dd"}');
              $('##{dom_id}').datepicker('option', 'yearRange', 'c-#{range.first.abs}:c+#{range.last}' );
              $('##{dom_id}').val('#{value}');
           });"
        end
      end
      
    end

    class FormBuilder #:nodoc:
      def date_field(method, options = {})
        @template.date_field(@object_name, method, objectify_options(options))
      end
    end
  end
end
=end