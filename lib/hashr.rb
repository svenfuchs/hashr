class Hashr < Hash
  autoload :EnvDefaults, 'hashr/env_defaults'

  TEMPLATE = new

  class << self
    def define(definition)
      @definition = definition
    end

    def definition
      @definition ||= {}
    end
  end

  def initialize(data = {})
    replace(deep_includize(deep_hasherize(deep_merge(self.class.definition, data))))
  end

  def []=(key, value)
    super(key, value.is_a?(Hash) ? self.class.new(value) : value)
  end

  def respond_to?(name)
    true
  end

  def method_missing(name, *args, &block)
    case name.to_s[-1]
    when '?'
      !!self[name.to_s[0..-2].to_sym]
    when '='
      self[name.to_s[0..-2].to_sym] = args.first
    else
      self[name]
    end
  end

  protected

    def deep_merge(left, right)
      merger = proc { |key, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? self.class.new(v1.merge(v2, &merger)) : v2 }
      left.merge(right || {}, &merger)
    end

    def deep_hasherize(hash)
      hash.inject(TEMPLATE.dup) do |result, (key, value)|
        result.merge(key.to_sym => value.is_a?(Hash) ? deep_hasherize(value) : value)
      end
    end

    def deep_includize(hash)
      if modules = hash.delete(:_include)
        meta_class = (class << hash; self end)
        Array(modules).each { |mod| meta_class.send(:include, mod) }
      end
      hash.inject(hash) do |hash, (key, value)|
        hash.merge(key => value.is_a?(Hash) ? deep_includize(value) : value)
      end
    end
end
