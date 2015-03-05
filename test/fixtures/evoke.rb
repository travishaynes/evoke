before_tasks do |task, *args|
  @before_hook = :called
end

class TaskA < Evoke::Task
  desc "Task A"

  def invoke
    @invoked = true
  end
end

class RootTask < Evoke::Task
  attr_reader :invoked

  def initialize
    @invoked = false
  end
end

class TaskB < RootTask
  desc "Task B"

  def invoke
    @invoked = true
  end
end
