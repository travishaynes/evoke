require 'test_helper'

module Evoke
  # Tests Evoke::Task
  class TaskTest < Minitest::Test
    # A test task with no arguments.
    class TestTaskNoArgs < Evoke::Task
      extend MockExit

      def invoke; end
    end

    # Used for testing tasks that has arguments.
    #
    # Additionally this class is used to test that the description is read from
    # the first line of this comment when the #desc class method is not used.
    class TestTaskWithArgs < Evoke::Task
      extend MockExit

      def invoke(a, b); end
    end

    # Used for testing tasks that have required and optional arguments.
    class TestTaskWithOptionalArgs < Evoke::Task
      extend MockExit
      desc 'A task with two required and three optional arguments.'
      def invoke(a, b, one='a', two='b', three='c'); end
    end

    class TestTaskNoDesc < Evoke::Task
      extend MockExit
      # Used for testing tasks that do not have a description.
      def invoke; end
    end

    # Used for testing tasks that use #syntax instead of the class comment.
    class TestTaskCustomSyntax < Evoke::Task
      extend MockExit
      syntax 'A custom syntax'
    end

    def setup
      @original_stderr = $stderr
      @original_stdout = $stdout

      $stderr = StringIO.new
      $stdout = StringIO.new
    end

    def teardown
      $stderr = @original_stderr
      $stdout = @original_stdout
    end

    def test_custom_syntax
      assert_equal 'A custom syntax', TestTaskCustomSyntax.syntax
    end

    def test_print_usage
      m1 = 'evoke/task_test/test_task_no_args    # A test task with no arguments.'
      m2 = 'evoke/task_test/test_task_with_args  # Used for testing tasks that has arguments.'
      m3 = 'evoke/task_test/test_task_no_desc    # No description available.'

      clear_stdout
      TestTaskNoArgs.print_usage(37)
      assert_equal m1, $stdout.string.strip,
        "should print the task's name and description to STDOUT"

      clear_stdout
      TestTaskWithArgs.print_usage(37)
      assert_equal m2, $stdout.string.strip,
        "should print the task's name and description to STDOUT"

      clear_stdout
      TestTaskNoDesc.print_usage(37)
      assert_equal m3, $stdout.string.strip,
        "should print the task's name and 'No description.' to STDOUT"
    end

    def test_validate_arguments_with_invalid_argument_size
      clear_stderr
      TestTaskWithOptionalArgs.validate_arguments([])
      assert_equal wrong_args_message(0, 2, 5), $stderr.string.strip

      clear_stderr
      TestTaskWithOptionalArgs.validate_arguments([1])
      assert_equal wrong_args_message(1, 2, 5), $stderr.string.strip

      clear_stderr
      TestTaskWithOptionalArgs.validate_arguments(%w(1 2 3 4 5 6))
      assert_equal wrong_args_message(6, 2, 5), $stderr.string.strip
    end

    def test_validate_arguments_with_args
      clear_stderr

      TestTaskWithArgs.validate_arguments([])

      assert_equal wrong_args_message(0, 2, 2), $stderr.string.strip,
        'should have written a wrong arguments error message to STDERR'

      assert_equal 1, TestTaskWithArgs.exit_code,
        'should have exited the application with exit-code 1'

      clear_stderr

      TestTaskWithArgs.validate_arguments(%w(a b))

      assert_equal '', $stderr.string,
        'should have not written anything to STDERR'
    end

    def test_validate_arguments_with_no_args
      clear_stderr

      TestTaskNoArgs.validate_arguments(1)

      assert_equal wrong_args_message(1, 0, 0), $stderr.string.strip,
        'should have written a wrong arguments error message to STDERR'

      assert_equal 1, TestTaskNoArgs.exit_code,
        'should have exited the application with exit-code 1'

      clear_stderr

      TestTaskNoArgs.validate_arguments([])

      assert_equal '', $stderr.string,
        'should have not written anything to STDERR'
    end

    private

    # Creates a wrong arguments error message.
    #
    # @param [Integer] size The size of the arguments supplied.
    # @param [Integer] min The minimum required arguments.
    # @param [Integer] max The maximum arguments with all options.
    # @return [String] An error message for failed assertions.
    def wrong_args_message(size, min, max)
      e = min == max ? min : "#{min}..#{max}"
      "Wrong number of arguments. Received #{size} instead of #{e}."
    end

    # Empties the STDERR buffer.
    def clear_stderr
      $stderr.string = ''
    end

    # Empties the STDOUT buffer.
    def clear_stdout
      $stdout.string = ''
    end
  end
end
