class Hash
  def slice(*keep_keys)
    h = {}
    keep_keys.each { |key| h[key] = fetch(key) }
    h
  end unless Hash.method_defined?(:slice)

  def except(*less_keys)
    slice(*keys - less_keys)
  end unless Hash.method_defined?(:except)

  def deep_symbolize_keys
    inject({}) { |result, (key, value)|
      value = value.deep_symbolize_keys if value.is_a?(Hash)
      result[(key.to_sym rescue key) || key] = value
      result
    }
  end unless Hash.method_defined?(:deep_symbolize_keys)

  # deep_merge_hash! by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
  def deep_merge(other)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    merge(other, &merger)
  end unless Hash.method_defined?(:deep_merge)
end
