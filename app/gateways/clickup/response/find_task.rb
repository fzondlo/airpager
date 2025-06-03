module Clickup
  class Response
    class FindTask < Response

      def id
        body[:id]
      end

      def status
        body.dig(:status, :status)
      end

      def start_date
        body[:start_date]
      end

      def due_date
        body[:due_date]
      end

      def due_date_readable
        date = Time.at(due_date.to_i / 1000)
        date.strftime("%-d.%-m.%Y")
      end

      def reservation_code
        custom_fields.dig(:reservation_code, :value)
      end

      def reservation_id
        custom_fields.dig(:reservation_id, :value)
      end

      def limpiadora
        get_dropdown_value_for_cf(custom_fields[:limpiadora], :name)
      end

      def limpiadora_id
        get_dropdown_value_for_cf(custom_fields[:limpiadora], :id)
      end

      def property_name
        get_dropdown_value_for_cf(custom_fields[:property_name], :name)
      end

      def property_id
        get_dropdown_value_for_cf(custom_fields[:property_name], :id)
      end

      private

      def custom_fields
        @custom_fields ||= body[:custom_fields].each_with_object({}) do |cf, memo|
          memo[cf[:name]] = cf
        end.with_indifferent_access
      end

      def get_dropdown_value_for_cf(cf, field_name)
        cf[:type_config][:options].select{|o| o[:orderindex] == cf[:value]}[0][field_name]
      end
    end
  end
end
