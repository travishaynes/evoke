require 'test_helper'

module Evoke
  class TaskTest < Minitest::Test
    class TestTask < Evoke::Task
      class << self
        attr_reader :exit_code

        def exit(code)
          @exit_code = code
        end
      end
    end

    class TestTaskNoArgs < TestTask
      desc "A test task with no arguments."
      def invoke; end
    end

    class TestTaskWithArgs < TestTask
      desc "A test task that has arguments"
      def invoke(a, b); end
    end

    class TestTaskNoDesc < TestTask
      def invoke; end
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

    def test_print_usage
      m1 = "evoke/task_test/test_task_no_args    # A test task with no arguments."
      m2 = "evoke/task_test/test_task_with_args  # A test task that has arguments."
      m3 = "evoke/task_test/test_task_no_desc    # No description."

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

    def test_validate_arguments_with_args
      clear_stderr

      TestTaskWithArgs.validate_arguments([])

      assert_equal wrong_args_message(2, 0), $stderr.string.strip,
        "should have written a wrong arguments error message to STDERR"

      assert_equal 1, TestTaskWithArgs.exit_code,
        "shold have exited the application with exit-code 1"

      clear_stderr

      TestTaskWithArgs.validate_arguments(%w[a b])

      assert_equal "", $stderr.string,
        "should have not written anything to STDERR"
    end

    def test_validate_arguments_with_no_args
      clear_stderr

      TestTaskNoArgs.validate_arguments(1)

      assert_equal wrong_args_message(0, 1), $stderr.string.strip,
        "should have written a wrong arguments error message to STDERR"

      assert_equal 1, TestTaskNoArgs.exit_code,
        "should have exited the application with exit-code 1"

      clear_stderr

      TestTaskNoArgs.validate_arguments([])

      assert_equal "", $stderr.string,
        "should have not written anything to STDERR"
    end

    private

    # Creates a wrong arguments error message.
    #
    # @param [Integer] e The expected count.
    # @param [Integer] a The actual count.
    # @return [String] An error message for failed assertions.
    def wrong_args_message(e, a)
      "Wrong number of arguments. Received #{a} instead of #{e}."
    end

    # Empties the STDERR buffer.
    def clear_stderr
      $stderr.string = ""
    end

    # Empties the STDOUT buffer.
    def clear_stdout
      $stdout.string = ""
    end
  end
end
