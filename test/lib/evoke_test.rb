require 'test_helper'

# Tests the class methods for the Evoke module.
class EvokeTest < Minitest::Test
  def setup
    remove_fixtures_const
  end

  def teardown
    remove_fixtures_const
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
