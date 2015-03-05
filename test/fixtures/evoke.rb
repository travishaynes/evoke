Evoke.before_task do |task, *args|
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

# This is a task that has two arguments. The first is required, the second is
# optional and defaults to "optional".
class ArgumentTest < Evoke::Task
  attr_reader :req, :opt

  def invoke(req, opt="optional")
    @req = req
    @opt = opt
  end
end
