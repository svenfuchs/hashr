require 'hashr/core_ext/ruby/hash'

class Hashr < Hash
  autoload :EnvDefaults, 'hashr/env_defaults'

  TEMPLATE = new

  class << self
    attr_accessor :raise_missing_keys

    def define(definition)
      @definition = definition.deep_symbolize_keys
    end

    def definition
      @definition ||= {}
    end
  end

  def initialize(data = {}, definition = self.class.definition)
    replace(deep_hashrize(definition.deep_merge(data.deep_symbolize_keys)))
  end

  def []=(key, value)
    super(key, value.is_a?(Hash) ? self.class.new(value, {}) : value)
  end

  def respond_to?(name)
    true
  end

  def method_missing(name, *args, &block)
    case name.to_s[-1, 1]
    when '?'
      !!self[name.to_s[0..-2].to_sym]
    when '='
      self[name.to_s[0..-2].to_sym] = args.first
    else
      raise(IndexError.new("Key #{name.inspect} is not defined.")) if !key?(name) && self.class.raise_missing_keys
      self[name]
    end
  end

  def include_modules(modules)
    Array(modules).each { |mod| meta_class.send(:include, mod) } if modules
  end

  def meta_class
    class << self; self end
  end

  protected

    def deep_hashrize(hash)
      hash.inject(TEMPLATE.dup) do |result, (key, value)|
        if key.to_sym == :_include
          result.include_modules(value)
        else
          result.store(key.to_sym, value.is_a?(Hash) ? deep_hashrize(value) : value)
        end
        result
      end
    end
end

