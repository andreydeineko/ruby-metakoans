def attribute(attribute_name, &block)
  if attribute_name.is_a?(Hash)
    attribute_name.each_pair { |key, value| append_attribute(key, value) }
  else
    append_attribute(attribute_name, block_given?? block : nil)
  end
end

def append_attribute(attr, attribute_value)
  define_method "#{attr}=".to_sym do |new_value|
    instance_variable_set '@' + attr, new_value
    instance_variable_set '@' + attr + '_defined', true
  end

  define_method(attr) do
    if instance_variable_get('@' + attr + '_defined')
      instance_variable_get('@' + attr)
    else
      attribute_value.is_a?(Proc) ? instance_eval(&attribute_value) : attribute_value
    end
  end

  define_method(attr.to_s + '?') do
    !send(attr.to_sym).nil?
  end
end