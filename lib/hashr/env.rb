class Hashr
  module Env
    class Vars < Struct.new(:defaults, :namespace)
      FALSE = [false, nil, 'false', 'nil', '']

      def to_h
        defaults.deep_merge(read_env(defaults, namespace.dup))
      end

      private

        def read_env(defaults, namespace)
          defaults.inject({}) do |result, (key, default)|
            keys = namespace + [key]
            value = default.is_a?(Hash) ? read_env(default, keys) : var(keys, default)
            result.merge(key => value)
          end
        end

        def var(keys, default)
          key = keys.map(&:upcase).join('_')
          value = ENV.fetch(key, default)
          cast(value, default, keys)
        end

        def cast(value, default, keys)
          case default
          when Array
            value.respond_to?(:split) ? value.split(',') : Array(value)
          when true, false
            not FALSE.include?(value)
          else
            value
          end
        end

        def namespace
          Array(super && super.upcase)
        end
    end

    attr_accessor :env_namespace

    def defaults
      Vars.new(super, env_namespace).to_h
    end
  end
end
