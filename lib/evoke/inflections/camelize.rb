module Evoke
  module Inflections
    # String inflections for converting to CamelCase.
    #
    # Camelizing a string takes all the compound words separated by an underscore
    # and combines them together, capitalizing the first letter of each word. It
    # also converts '/' to '::'. For example "hello_world" is camelized to
    # "HelloWorld", and "hello/world" is camelized to "Hello::World".
    module Camelize
      # Converts a string to CamelCase. It also converts '/' to '::'.
      #
      # @example Camelize the string "example/hello_world".
      #
      #     "example/hello_world".camelize # => "Example::HelloWorld"
      #
      # @return [String] The CamelCase string.
      def camelize
        dup.tap do |s|
          s.capitalize!
          s.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
          s.gsub!('/', '::')
        end
      end

      # Replaces the existing String instance with a CamelCase string.
      #
      # @example Camelizing the string "example/hello_world".
      #
      #     string = "example/hello_world"
      #     string.camelize!
      #     string # => "Example::HelloWorld"
      #
      # @return [String] This string modified to CamelCase.
      def camelize!
        replace(camelize)
      end
    end
  end
end
