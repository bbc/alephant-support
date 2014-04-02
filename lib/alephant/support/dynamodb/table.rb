module Alephant
  module Support
    module DynamoDB
      class Table
        TIMEOUT = 120
        DEFAULT_CONFIG = {
          :write_units => 5,
          :read_units => 10,
        }
        SCHEMA = {
          :hash_key => {
            :key => :string,
            :value => :string
          }
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
          table.items.collect do |item|
            construct_attributes_from item
          end
        end

        def construct_attributes_from(item)
          range_key? ? [item.hash_value, item.range_value.to_i] : item.hash_value
        end

        def range_key?
          @range_found ||= table.items.first.range_value
        end
      end
    end
  end
end
