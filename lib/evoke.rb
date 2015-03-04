require 'evoke/version'
require 'evoke/task'

module Evoke
  # Gets all the classes that descend from Evoke::Task.
  #
  # @return [Array] The task classes.
  def self.tasks
    ObjectSpace.each_object(Class).select {|klass| klass < Evoke::Task }
  end

  # Loads all the Evoke tasks in the supplied path.
  #
  # @param [String] path The root path that contains the tasks.
  #
  # @note The path is relative to the file that called #load_tasks.
  def self.load_tasks(path)
    root = File.expand_path("../", caller[0].split(":")[0])
    search = File.join(root, path, "**", "*_task.rb")
    Dir[search].each {|f| load f }
  end
end
