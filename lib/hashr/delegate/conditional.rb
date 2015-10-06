class Hashr
  module Delegate
    module Conditional
      def method_missing(name, *args, &block)
        if (args.any? || block) && @data.respond_to?(name)
          @data.send(name, *args, &block)
        else
          super
        end
      end
    end
  end
end
