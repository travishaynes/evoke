require 'test_helper'

module Evoke
  # Tests Evoke::Parameters
  class ParametersTest < Minitest::Test

    # A test class for inspecting parameters.
    class Arguments
      extend Evoke::Parameters

      def param_noargs; end
      def param_one_required_arg(arg1); end
      def param_two_required_args(arg1, arg2); end
      def param_one_optional_arg(opt='optional'); end
      def param_two_optional_args(opt1='first', opt2='second'); end
      def param_req_and_opt(arg1, opt='optional'); end
      def unsupported_arg(&block); end
    end

    def test_unsupported_argument
      method = Arguments.instance_method(:unsupported_arg)

      error = assert_raises(ArgumentError) do
        Arguments.parameter_names(method)
      end

      message = '#unsupported_arg uses unsupported parameter type for block'
      assert_equal message, error.message
    end

    def test_parameter_names
      method = Arguments.instance_method(:param_noargs)
      assert_equal [], Arguments.parameter_names(method)

      method = Arguments.instance_method(:param_one_required_arg)
      assert_equal %w(ARG1), Arguments.parameter_names(method)

      method = Arguments.instance_method(:param_two_required_args)
      assert_equal %w(ARG1 ARG2), Arguments.parameter_names(method)

      method = Arguments.instance_method(:param_one_optional_arg)
      assert_equal %w([OPT]), Arguments.parameter_names(method)

      method = Arguments.instance_method(:param_two_optional_args)
      assert_equal %w([OPT1] [OPT2]), Arguments.parameter_names(method)

      method = Arguments.instance_method(:param_req_and_opt)
      assert_equal %w(ARG1 [OPT]), Arguments.parameter_names(method)
    end

    def test_required_parameters
      method = Arguments.instance_method(:param_noargs)
      assert_equal [], Arguments.required_parameters(method)

      method = Arguments.instance_method(:param_one_required_arg)
      assert_equal [:arg1], Arguments.required_parameters(method)

      method = Arguments.instance_method(:param_two_required_args)
      assert_equal [:arg1, :arg2], Arguments.required_parameters(method)
    end

    def test_optional_parameters
      method = Arguments.instance_method(:param_one_optional_arg)
      assert_equal [:opt], Arguments.optional_parameters(method)

      method = Arguments.instance_method(:param_two_optional_args)
      assert_equal [:opt1, :opt2], Arguments.optional_parameters(method)

      method = Arguments.instance_method(:param_req_and_opt)
      assert_equal [:opt], Arguments.optional_parameters(method)
    end
  end
end
