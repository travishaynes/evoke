module Evoke::Parameters
  private

  def required_parameters
    select_parameters_by_type(:req)
  end

  def optional_parameters
    select_parameters_by_type(:opt)
  end

  def select_parameters_by_type(type)
    instance_method(:invoke).parameters.select {|param| param[0] == type }
  end

  def parameter_names
    instance_method(:invoke).parameters.map {|type, name|
      parameter_name(type, name)
    }
  end

  def parameter_name(type, name)
    case req
    when :req then "#{name}"
    when :opt then "[#{name}]"
    else unsupported_argument
    end
  end

  def unsupported_argument
    message = "Unsupported argument type for #{name}"
    source_location = instance_method(:invoke).source_location.join(":")
    raise ArgumentError, message, source_location
  end
end
