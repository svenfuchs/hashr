class Hashr
  module Delegation
    module Hash
      METHODS = [
        :all?,
        :any?,
        :clear,
        :delete,
        :delete_if,
        :detect,
        :drop,
        :drop_while,
        :each,
        :empty?,
        :fetch,
        :find,
        :flat_map,
        :grep,
        :group_by,
        :hash,
        :inject,
        :invert,
        :is_a?,
        :keep_if,
        :key,
        :key?,
        :keys,
        :length,
        :map,
        :merge,
        :nil?,
        :none?,
        :one?,
        :reduce,
        :reject,
        :select,
        :size,
        :value?,
        :values,
        :values_at
      ]

      METHODS.each do |name|
        define_method(name) { |*args, &block| @data.send(name, *args, &block }
      end
    end
  end
end
