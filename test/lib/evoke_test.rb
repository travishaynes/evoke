require 'test_helper'

# Tests the class methods for the Evoke module.
class EvokeTest < Minitest::Test
  # Used to test Evoke#before_task callback.
  class CallbackTestTask < Evoke::Task
    desc 'A test task used for callback hooks'
    def invoke(a, b); end
  end

  def setup
    remove_fixtures_const
  end

  def teardown
    remove_fixtures_const

    # Remove any callback hooks used in these tests
    Evoke.instance_variable_set('@before_hooks', nil)
  end

  def test_before_callback
    @hook_called = false
    @task = nil
    @args = nil

    Evoke.before_task do |task, *args|
      @hook_called = true
      @task = task
      @args = args
    end

    Evoke.invoke(CallbackTestTask, 'arg1', 'arg2')

    assert @hook_called
    assert @task.is_a?(CallbackTestTask)
    assert_equal %w(arg1 arg2), @args
  end

  def test_load_tasks
    assert !defined?(Fixtures::ExampleTask)
    Evoke.load_tasks('test/fixtures/lib/tasks')
    assert defined?(Fixtures::ExampleTask)
  end

  def test_tasks
    Evoke.load_tasks('test/fixtures/lib/tasks')
    assert Evoke.tasks.include?(Fixtures::ExampleTask)
  end

  def test_find_task
    Evoke.load_tasks('test/fixtures/lib/tasks')
    task = Evoke.find_task('fixtures/example_task')
    assert_equal Fixtures::ExampleTask.name, task.name
    assert_nil Evoke.find_task('not/a_valid/task')
  end

  private

  def remove_fixtures_const
    Object.send(:remove_const, :Fixtures) if defined?(Fixtures)
  end
end
