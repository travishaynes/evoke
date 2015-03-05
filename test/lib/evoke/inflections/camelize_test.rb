require 'test_helper'

module Evoke::Inflections
  class CamelizeTest < Minitest::Test
    def test_string_responds_to_camelize_methods
      assert String.new.respond_to?(:camelize)
      assert String.new.respond_to?(:camelize!)
    end

    def test_camelize
      assert_equal "Inflections::HelloWorld", "inflections/hello_world".camelize
    end

    def test_camelize!
      string = "inflections/hello_world"
      string.camelize!
      assert_equal "Inflections::HelloWorld", string
    end
  end
end
