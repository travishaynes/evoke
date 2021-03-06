module Evoke
  # The command-line-interface for Evoke.
  class CLI
    def initialize
      @command = ARGV.shift
      @arguments = ARGV.dup

      ARGV.clear
    end

    # Starts the CLI. This will check lib/tasks in the current working directory
    # for evoke tasks and invoke the task supplied on the command line.
    def start
      load_tasks

      return no_tasks if tasks.empty?
      return usage if @command.nil?
      return syntax if @command == 'help'

      task = Evoke.find_task(@command) unless @command.nil?

      return unknown_command if task.nil?

      Evoke.invoke(task, *@arguments)
    end

    private

    # Prints the syntax usage of the task requested by help.
    def syntax
      return usage if @arguments.empty?

      @command = @arguments.shift

      task = Evoke.find_task(@command)

      return unknown_command if task.nil?

      task.print_syntax

      exit(2)
    end

    # Prints the usage for all the discovered tasks.
    def usage
      grouped_tasks = task_names.group_by(&:size)
      name_sizes = grouped_tasks.keys
      biggest_name = name_sizes.max || 0
      tasks.each { |task| task.print_usage(biggest_name + 2) }

      exit(2)
    end

    # Gets the path for the local evoke.rb file. This doesn't check if the file
    # actually exists, it only returns the location where it might be.
    #
    # @return [String] The path for the evoke file.
    def evoke_file
      @evoke_file = File.join(Dir.pwd, 'evoke.rb')
    end

    # Loads the Evoke tasks. This will first search for a file named `evoke.rb`
    # in the current working directory. If one is found it will be loaded. If
    # none is found the default working directory's lib/tasks folder will be
    # used to load the tasks.
    def load_tasks
      return load(evoke_file) if File.file?(evoke_file)

      # Load the tasks from the current working directory.
      Evoke.load_tasks('lib/tasks')
    end

    # Tells the user there are no tasks to invoke and exits with status 1.
    def no_tasks
      $stderr.puts 'No tasks found in the current working directory.'
      exit(1)
    end

    # Tells the user that the supplied task could not be found.
    def unknown_command
      $stderr.puts "No task named #{@command.inspect}"
      exit(1)
    end

    # Finds and caches all the Evoke tasks.
    #
    # @return [Array] The tasks.
    def tasks
      @tasks ||= Evoke.tasks
    end

    # Gets the underscored names of all the tasks and caches it. These are the
    # names are that used on the command line.
    #
    # @return [Array] The name of all the tasks.
    def task_names
      @task_names ||= tasks.map { |task| task.name.underscore }
    end
  end
end
