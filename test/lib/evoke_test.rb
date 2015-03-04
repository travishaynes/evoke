require 'test_helper'

class EvokeTest < Minitest::Test
  def teardown
    Object.send(:remove_const, :Fixtures) if defined?(Fixtures)
  end

  def test_load_tasks
    assert !defined?(Fixtures::ExampleTask)
    Evoke.load_tasks("../fixtures/tasks")
    assert defined?(Fixtures::ExampleTask)
  end

  def test_tasks
    Evoke.load_tasks("../fixtures/tasks")
    assert Evoke.tasks.include?(Fixtures::ExampleTask)
  end
end
