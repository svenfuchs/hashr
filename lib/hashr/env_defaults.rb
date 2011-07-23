class Hashr < Hash
  module EnvDefaults
    def definition
      deep_enverize(super)
    end

    protected

      def deep_enverize(hash, nesting = ['WORKER'])
        hash.each do |key, value|
          nesting << key.to_s.upcase
          hash[key] = case value
          when Hash
            deep_enverize(value, nesting)
          else
            ENV.fetch(nesting.join('_'), value)
          end.tap { nesting.pop }
        end
      end
  end
end
