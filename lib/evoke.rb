require 'evoke/version'
require 'evoke/task'

module Evoke
  require 'evoke/inflections'

  class << self
    # Gets all the classes that descend from Evoke::Task.
    #
    # @return [Array] The task classes.
    def tasks
      ObjectSpace.each_object(Class).select {|klass|
        klass < Evoke::Task && klass.instance_methods.include?(:invoke)
      }
    end

    # Finds a task with the supplied name.
    #
    # @param [String] name The underscored name of the task.
    # @return [Evoke::Task] The task or nil if not found.
    # @example Find a task that has the class name `Example::HelloWorld`.
    #
    #     Evoke.find_task('example/hello_world') # => Example::HelloWorld
    #
    def find_task(name)
      tasks.find {|task| task.to_s == name.camelize }
    end

    # Loads all the Evoke tasks in the supplied path.
    #
    # @param [String] path The root path that contains the tasks.
    # @note The path is relative to the file that called #load_tasks.
    def load_tasks(path)
      root = File.expand_path("../", caller[0].split(":")[0])
      search = File.join(root, path, "**", "*_task.rb")
      Dir[search].each {|f| load f }
    end

    # Adds a code block that will be called before the task is invoked.
    #
    # @param [Proc] &block The code to execute before the task is invoked.
    # @example Loading the Rails environment before running any Evoke tasks.
    #
    #     # File: evoke.rb - In the Rails application's root path
    #
    #     Evoke.before_task {|task, *args|
    #       require File.expand_path("../config/environment.rb", __FILE__)
    #     }
    #
    def before_task(&block)
      @before_hooks ||= []
      @before_hooks << block if block_given?
    end

    # Creates an instance of a task, validates the amount of arguments supplied
    # matches the task's #invoke method, executes the #before_task callbacks,
    # and invokes the task.
    #
    # @param [Class] task The Evoke::Task class to invoke.
    # @param [Array] *arguments The arguments to invoke the task with.
    def invoke(task, *arguments)
      task.validate_arguments(arguments)
      task = task.new
      Evoke.call_before_hooks(task, *arguments)
      task.invoke(*arguments)
    end

    protected

    # Executes the before callbacks.
    #
    # @param [Evoke::Task] task The task instance that is being invoked.
    # @param [Array] args The arguments that are being passed to the task.
    def call_before_hooks(task, *args)
      Array(@before_hooks).each {|hook| hook.call(*args) }
    end
  end
end
