class Hash
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
  end unless instance_methods.include?(:deep_symbolize_keys)

  # deep_merge_hash! by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
  def deep_merge(other)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    merge(other, &merger)
  end unless instance_methods.include?(:deep_merge)
end
