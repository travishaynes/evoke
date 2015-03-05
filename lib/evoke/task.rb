module Evoke
  class Task
    class << self
      # Prints the usage of this task to the console.
      #
      # @param [Integer] name_col_size The size of the name column.
      # @private
      def print_usage(name_col_size)
        $stdout.print name.underscore.ljust(name_col_size)
        $stdout.puts "# #{@desc || 'No description.'}"
      end

      # Describes the task. This message will be printed to the console when
      # evoke is called without any arguments.
      #
      # @note All descriptions end with a period. One will be added if missing.
      #
      # @param [String] value The description. Keep it short!
      # @return [String] The supplied description.
      def desc(value)
        value += "." unless value.end_with?(?.)
        @desc = value
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
