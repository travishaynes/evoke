module Evoke
  class Task
    extend Evoke::Comment
    extend Evoke::Parameters

    class << self
      # Prints the name and description of this task to the console.
      #
      # @param [Integer] name_col_size The size of the name column.
      # @private
      def print_usage(name_col_size)
        $stdout.print name.underscore.ljust(name_col_size)
        $stdout.puts "# #{@desc || 'No description.'}"
      end

      # Prints the syntax usage for this task to the console.
      # @private
      def print_syntax
        $stdout.puts "Usage: #{name.underscore}" # TODO add parameters
        $stdout.puts "\n#{syntax}"
      end

      # A short, one line description of the task.
      #
      # This message will be printed to the console when evoke is called without
      # any arguments.
      #
      # @note All descriptions end with a period. One will be added if missing.
      #
      # @param [String] value The description. Keep it short!
      # @return [String] The supplied description.
      def desc(value)
        value += "." unless value.end_with?(?.)
        @desc = value
      end

      # Describes the syntax of the task.
      #
      # The syntax is displayed to the user when they call `evoke help` for this
      # task. This can be a detailed, multi-line description of how to use the
      # task. By default the comment before the task's class will be used.
      #
      # @param [String] value The details on how to use the task.
      # @return [String] The syntax - this method is both a getter and setter.
      def syntax(value=nil)
        if value.nil?
          @syntax ||= class_comment
        else
          @syntax = value unless value.nil?
        end

        @syntax
      end

      # Ensures that the task's #invoke method has the same amount of arguments
      # as the user supplied on the command-line. If not, an error message is
      # printed to STDERR and Evoke is terminated with an exit-status of 1.
      #
      # @param [Array] arguments The arguments to validate.
      # @return nil if the validation passes.
      # @private
      def validate_arguments(arguments)
        e_size = instance_method(:invoke).arity
        a_size = Array(arguments).size

        return if e_size == a_size

        $stderr.print "Wrong number of arguments. "
        $stderr.print "Received #{a_size} instead of #{e_size}.\n"
        exit(1)
      end
    end
  end
end
