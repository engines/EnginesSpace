class Hash

  def symbolize_keys = transform_keys(&:to_sym)

  def stringify_keys = transform_keys(&:to_s)

  def snakize_keys = transform_keys { |k| k.snakize.to_sym }

  def with(*keys) =
    keys.inject({}) do |m, k|
      m.tap { m[k] = itself[k] }
    end.compact

  def without(*keys) = with(*(itself.keys - keys))

  def clean = compact.delete_if { |k, v| v == '' }

  def reverse_merge(other) = other ? other.merge(self) : self

  def deep_merge(other, &block)
    dup.deep_merge!(other, &block)
  end

  def to_struct =
    OpenStruct.new(snakize_keys.values_to_struct)

  def to_hcl(enclosed: true) =
    %(#{'{' if enclosed}
      #{keys.map { |k| hcl_for(k) }.join("\n")}
      #{'}' if enclosed}
    )

  def hcl_for(key) =
    %(#{key} = #{self[key].to_hcl})

  def no_symbols = deep(:no_symbols, of: :keys).deep(:no_symbols)
  def values_to_struct = deep(:to_struct)

  def deep(method, of: :values)
    send("transform_#{of}") { |v| v.deep(method, of: of) }.
    transform_values { |v| (v.respond_to?(:keys) && of == :keys) ? v.deep(method, of: :keys) : v }
  end

  def deep_to_h
    transform_keys(&:deep_to_h).transform_values(&:deep_to_h)
  end

  def deep_to_struct
    OpenStruct.new(
      transform_keys(&:deep_to_struct).transform_values(&:deep_to_struct)
    )
  end


protected

  def reverse_merge!(other)
    replace(reverse_merge(other))
  end

  def deep_merge!(other, &block)
    merge!(other) do |key, this_val, other_val|
      if this_val.is_a?(Hash) && other_val.is_a?(Hash)
        this_val.deep_merge(other_val, &block)
      elsif block_given?
        block.call(key, this_val, other_val)
      else
        other_val
      end
    end
  end

end
