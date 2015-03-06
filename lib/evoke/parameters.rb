module Evoke
  # Extendable module for providing access to method parameters during runtime.
  module Parameters
    # Finds the minimum and maximum amount of parameters the supplied method
    # supports.
    #
    # @param [UnboundMethod] method The method to check.
    # @return [Array] The first item is the minimum size, second is the maximum.
    def parameter_size(method)
      req_size = required_parameters(method).size
      opt_size = optional_parameters(method).size

      [req_size, req_size + opt_size]
    end

    # Gets all the required parameters for a method.
    #
    # @param [UnboundMethod] method The method to scan.
    # @return [Array] An array of the method names.
    def required_parameters(method)
      select_parameters_by_type(method, :req)
    end

    # Gets all the optional parameters for a method.
    #
    # @param [UnboundMethod] method The method to scan.
    # @return [Array] An array of the method names.
    def optional_parameters(method)
      select_parameters_by_type(method, :opt)
    end

    # Finds all the parameters of a given type for the supplied method.
    #
    # @example Get the key parameters for a method.
    #
    #     class Example
    #       extend Evoke::Parameters
    #
    #       def hello(to: "world")
    #         puts "Hello #{to}"
    #       end
    #     end
    #
    #     method = Example.instance_method(:hello)
    #     key_params = Example.select_parameters_by_type(method, :key)
    #
    # @param [UnboundMethod] method The method to scan.
    # @param [Symbol] type The type of method.
    # @return [Array] An array of the method names.
    def select_parameters_by_type(method, type)
      args = method.parameters.select { |param| param[0] == type }
      args.map { |arg| arg[1] }
    end

    # Parses the parameters for the supplied method into parameters that can be
    # understood by humans. The method names are capitalized. Optional
    # parameters are surrounded in brackets.
    #
    # @note Key and &block parameters are not supported.
    #
    # @param [UnboundMethod] method The method to scan.
    # @return [Array] The human-readable method names.
    # @raise [ArgumentError] if an unsupported parameter type is detected.
    def parameter_names(method)
      method.parameters.map { |type, name| parameter_name(method, type, name) }
    end

    private

    # Parses a method parameter into a format that humans can understand.
    #
    # @param [UnboundMethod] method The method the parameter belongs to.
    # @param [Symbol] type The parameter's type. Only :req and :opt supported.
    # @param [Symbol] name The method's name.
    # @return [String] The formatted parameter name.
    # @raise [ArgumentError] if an unsupported parameter type is supplied.
    # @private
    def parameter_name(method, type, name)
      case type
      when :req then name.to_s.upcase
      when :opt then "[#{name.to_s.upcase}]"
      else unsupported_argument(method, name)
      end
    end

    # Raised when a method has an unsupported parameter type.
    #
    # @param [UnboundMethod] method The method the parameter belongs o.
    # @param [Symbol] name The method's name.
    # @raise [ArgumentError] Backtraces to the source of the method.
    # @private
    def unsupported_argument(method, name)
      message = "##{method.name} uses unsupported parameter type for #{name}"
      source_location = method.source_location.join(':')
      fail ArgumentError, message, source_location
    end
  end
end
