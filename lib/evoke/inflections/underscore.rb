# String inflections for converting to underscored form.
#
# Underscoring a string injects an underscore between CamelCase words, replaces
# all '::' with '/' and converts the string to lowercase. For example, the
# string "HelloWorld" is underscored to "hello_world", and the string
# "Hello::World" is underscored to "hello/world".
module Evoke::Inflections::Underscore
  # Creates an underscored, lowercase form of the string and changes '::' to '/'
  # to convert namespaces to paths.
  #
  # @example Underscoring "Example::HelloWorld".
  #
  #     "Example::HelloWorld" # => "example/hello_world"
  #
  # @return [String] The underscored string.
  def underscore
    dup.tap {|s|
      s.gsub!(/::/, '/')
      s.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      s.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      s.tr!("-", "_")
      s.downcase!
    }
  end

  # Replaces the existing String instance with its underscored form.
  #
  # @example Underscoring the string "Example::HelloWorld".
  #
  #     string = "Example::HelloWorld"
  #     string.underscore!
  #     string # => "example/hello_world"
  #
  # @return [String] This underscored form of the original string.
  def underscore!
    replace(underscore)
  end
end
