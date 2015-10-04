class Hashr < BasicObject
  require 'hashr/core_ext/ruby/hash'
  require 'hashr/env_defaults'

  class << self
    attr_reader :defaults

    def inherited(other)
      other.default(defaults)
    end

    def new(*args)
      super(self, *args)
    end

    def default(defaults)
      @defaults = (self.defaults || {}).deep_merge(defaults || {})
    end
    alias :define :default

    def const_missing(name)
      Kernel.const_get(name)
    end
  end

  attr_reader :class

  def initialize(klass, data = nil, defaults = nil, &block)
    ::Kernel.fail ::ArgumentError.new("Invalid input #{data.inspect}") unless data.nil? || data.is_a?(::Hash)

    data = (data || {}).deep_symbolize_keys
    defaults = (defaults || klass.defaults || {}).deep_symbolize_keys

    @class = klass
    @data = defaults.deep_merge(data).inject({}) do |result, (key, value)|
      result.merge(key => value.is_a?(::Hash) ? ::Hashr.new(value, {}) : value)
    end
  end

  def defined?(key)
    @data.key?(key.respond_to?(:to_sym) ? key.to_sym : key)
  end

  def [](key)
    @data[key.to_s] || @data[key.to_sym]
  end

  def []=(key, value)
    @data.store(key, value.is_a?(::Hash) ? self.class.new(value, {}) : value)
  end

  def values_at(*keys)
    keys.map { |key| self[key] }
  end

  def respond_to?(method)
    true
  end

  def method_missing(name, *args, &block)
    case name.to_s[-1, 1]
    when '?'
      !!self[name.to_s[0..-2]]
    when '='
      self[name.to_s[0..-2]] = args.first
    else
      self[name]
    end
  end

  def to_h
    @data.inject({}) do |hash, (key, value)|
      hash.merge(key => value.respond_to?(:to_h) ? value.to_h : value)
    end
  end
  alias to_hash to_h

  def inspect
    "<Hashr #{@data.inspect}>"
  end

  def ==(other)
    to_h == other.to_h if other.respond_to?(:to_h)
  end

  def instance_of?(const)
    self.class == const
  end

  def is_a?(const)
    consts = [self.class]
    consts << consts.last.superclass while consts.last.superclass
    consts.include?(const)
  end
  alias kind_of? is_a?
end
