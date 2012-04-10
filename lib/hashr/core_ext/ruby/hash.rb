class Hash
  def slice(*keep_keys)
    h = {}
    keep_keys.each { |key| h[key] = fetch(key) if key?(key) }
    h
  end unless Hash.method_defined?(:slice)

  def except(*less_keys)
    slice(*keys - less_keys)
  end unless Hash.method_defined?(:except)

  def deep_symbolize_keys
     symbolizer = lambda do |value|
      case value
      when Hash
        value.deep_symbolize_keys
      when Array
        value.map { |value| symbolizer.call(value) }
      else
        value
      end
    end
    inject({}) do |result, (key, value)|
      result[(key.to_sym rescue key) || key] = symbolizer.call(value)
      result
    end
  end

  def deep_symbolize_keys!
    replace(deep_symbolize_keys)
  end

  # deep_merge_hash! by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
  def deep_merge(other)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    merge(other, &merger)
  end unless Hash.method_defined?(:deep_merge)
end
