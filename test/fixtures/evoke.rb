Evoke.before_task { @before_hook = :called }

# Syntax for task A.
class TaskA < Evoke::Task
  desc 'Task A'

  def invoke
    @invoked = true
  end
end

# This is not a task that can be invoked.
class RootTask < Evoke::Task
  attr_reader :invoked

  def initialize
    @invoked = false
  end
end

# Syntax for task B.
class TaskB < RootTask
  desc 'Task B'

  def invoke
    @invoked = true
  end
end

# This is a task that has two arguments. The first is required, the second is
# optional and defaults to "optional".
class ArgumentTask < Evoke::Task
  attr_reader :req, :opt

  def invoke(req, opt='optional')
    @req = req
    @opt = opt
  end
end
