require 'test_helper'

class EvokeTest < Minitest::Test
  def teardown
    Object.send(:remove_const, :Fixtures) if defined?(Fixtures)
  end

  def test_load_tasks
    assert !defined?(Fixtures::ExampleTask)
    Evoke.load_tasks("test/fixtures/lib/tasks")
    assert defined?(Fixtures::ExampleTask)
  end

  def test_tasks
    Evoke.load_tasks("test/fixtures/lib/tasks")
    assert Evoke.tasks.include?(Fixtures::ExampleTask)
  end

  def test_find_task
    Evoke.load_tasks("test/fixtures/lib/tasks")
    task = Evoke.find_task("fixtures/example_task")
    assert_equal Fixtures::ExampleTask.name, task.name
    assert_nil Evoke.find_task("not/a_valid/task")
  end
end
