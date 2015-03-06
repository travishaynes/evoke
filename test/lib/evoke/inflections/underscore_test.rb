require 'test_helper'

module Evoke
  module Inflections
    class UnderscoreTest < Minitest::Test
      def test_string_has_underscore_methods
        assert ''.respond_to?(:underscore)
        assert ''.respond_to?(:underscore!)
      end

      def test_underscore
        string = 'Underscore::HelloWorld'
        assert_equal 'underscore/hello_world', string.underscore
      end

      def test_underscore!
        string = 'Underscore::HelloWorld'
        string.underscore!
        assert_equal 'underscore/hello_world', string
      end
    end
  end
end
