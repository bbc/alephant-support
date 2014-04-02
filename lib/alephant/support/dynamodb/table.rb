module Alephant
  module Support
    module DynamoDB
      class Table
        TIMEOUT = 120
        DEFAULT_CONFIG = {
          :write_units => 5,
          :read_units => 10,
        }

        def table
          raise NotImplementedError
        end

        def truncate!
          batch_delete table_data
        end

        private

        def batch_delete(rows)
          rows.each_slice(25) { |arr| table.batch_delete(arr) }
        end

        def table_data
          table.load_schema unless table.schema_loaded?
          table.items.collect do |item|
            construct_attributes_from item
          end
        end

        def construct_attributes_from(item)
          no_range_key? ? item.hash_value : [item.hash_value, item.range_value.to_i]
        end

        def no_range_key?
          @range_found ||= table.range_key.nil?
        end
      end
    end
  end
end
