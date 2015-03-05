require 'test_helper'

module Evoke::Inflections
  class UnderscoreTest < Minitest::Test
    def test_string_has_underscore_methods
      assert String.new.respond_to?(:underscore)
      assert String.new.respond_to?(:underscore!)
    end

    def test_underscore
      assert_equal 'underscore/hello_world', 'Underscore::HelloWorld'.underscore
    end

    def test_underscore!
      string = "Underscore::HelloWorld"
      string.underscore!
      assert_equal "underscore/hello_world", string
    end
  end
end
