require 'test_helper'

module Evoke
  module Inflections
    class CamelizeTest < Minitest::Test
      def test_string_responds_to_camelize_methods
        assert ''.respond_to?(:camelize)
        assert ''.respond_to?(:camelize!)
      end

      def test_camelize
        string = 'inflections/hello_world'
        assert_equal 'Inflections::HelloWorld', string.camelize
      end

      def test_camelize!
        string = 'inflections/hello_world'
        string.camelize!
        assert_equal 'Inflections::HelloWorld', string
      end
    end
  end
end
