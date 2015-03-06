require 'test_helper'
require 'evoke/cli'

module Evoke
  # A testable version of the CLI that includes an #exit method so the tests
  # don't actually exit the application.
  class TestableCLI < Evoke::CLI
    attr_reader :exit_code

    def exit(exit_code)
      @exit_code = exit_code
    end
  end

  # A task to invoke in the tests.
  class CliTestTask < Evoke::Task
    desc 'CLI test task'

    class << self
      def invocations
        @invocations || 0
      end

      def add_invocation
        @invocations = invocations + 1
      end
    end

    def invoke
      CliTestTask.add_invocation
    end
  end

  # Tests the command-line-interface.
  class CLITest < Minitest::Test
    def setup
      Evoke.load_tasks('test/fixtures/lib/tasks')
    end

    def test_no_tasks
      mock_stderr
      cli = TestableCLI.new
      cli.instance_variable_set('@tasks', [])
      cli.start
      expected_output = 'No tasks found in the current working directory.'
      assert_equal expected_output, $stderr.string.strip
      assert_equal 1, cli.exit_code
    ensure
      restore_stderr
    end

    def test_invoking_a_task
      start = CliTestTask.invocations
      mock_command('evoke/cli_test_task')
      cli = Evoke::CLI.new
      cli.start
      assert_equal start + 1, CliTestTask.invocations
    end

    def test_command_and_arguments
      mock_command('this/is_the_command', 'argument1', 'argument2')

      cli = Evoke::CLI.new

      command = cli.instance_variable_get('@command')
      arguments = cli.instance_variable_get('@arguments')

      assert_equal 'this/is_the_command', command
      assert_equal 2, arguments.size
      assert_equal 'argument1', arguments[0]
      assert_equal 'argument2', arguments[1]

      assert ARGV.empty?, 'CLI should clear ARGV'
    end

    def test_help_with_no_task
      mock_stdout
      mock_command('help')
      cli = TestableCLI.new
      cli.start
      assert $stdout.string.include?('evoke/cli_test_task')
      assert $stdout.string.include?('  # CLI test task.')
      assert_equal 2, cli.exit_code
    ensure
      restore_stdout
    end

    def test_help_with_invalid_task
      mock_stderr
      mock_command('help', 'invalid_task!')
      cli = TestableCLI.new
      cli.start
      assert_equal 'No task named "invalid_task!"', $stderr.string.strip
      assert_equal 1, cli.exit_code
    ensure
      restore_stderr
    end

    def test_help_with_valid_task
      mock_stdout
      mock_command('help', 'fixtures/example_task')
      cli = TestableCLI.new
      cli.start
      expected_output = read_fixture('example_task_syntax.txt')
      assert_equal expected_output, $stdout.string
      assert_equal 2, cli.exit_code
    ensure
      restore_stdout
    end

    private

    # Clears ARGV and replaces it with the supplied command and arguments.
    #
    # @param [String] command The command to mock.
    # @param [Array] *args The arguments.
    # @return [Array] The new value of ARGV.
    # @private
    def mock_command(command, *args)
      ARGV.clear
      ARGV << command
      ARGV.concat(args)
    end
  end
end
