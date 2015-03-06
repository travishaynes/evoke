module Evoke
  # Extendable module for extracting multi-line comments for a class at runtime.
  #
  # @example Reading the comment of a class.
  #
  #     # This is the multi-line
  #     # comment that will be read.
  #     class HelloWorld
  #       extend Evoke::Comment
  #     end
  #
  #     HelloWorld.class_comment # => the multi-line comment before the class
  #
  module Comment
    # Extracts the comment prefixing a class.
    #
    # @return [String] The class' comment.
    def class_comment
      @class_comment ||= extract_class_comment
    end

    private

    # Reads the class's file and extracts the comment of the class that extends
    # this module.
    #
    # @return [String] The multi-line string before the class.
    def extract_class_comment
      bottom_line, lines = start_index_and_code_lines

      comment = []

      (bottom_line - 1).downto(0).each do |i|
        line = parse_comment_line(lines[i])
        break if line == false
        comment << line
      end

      comment.reverse.join("\n").strip
    end

    # Parses a line of code and extracts the comment if present.
    #
    # @param [String] line The line of code to parse.
    # @return [NilClass] if the line is empty.
    # @return [Boolean] false if the line is not a comment.
    # @return [String] The extracted comment, without the prefixed # tag.
    # @private
    def parse_comment_line(line)
      line = line.strip
      return if line.empty?
      line.start_with?('#') ? line[1..line.length].strip : false
    end

    # Gets the lines in the class file and the line number that the class is
    # actually defined.
    #
    # @param [Array] The start position is first, followed by the code lines.
    # @private
    def start_index_and_code_lines
      data = read_class_file
      pos = data =~ /class.*\s*#{simple_name}.*\s*\<.*/
      [data[0..pos].count("\n"), data.split("\n")]
    end

    # The name of the class without a namespace.
    #
    # @return [String] The class' simple name.
    # @private
    def simple_name
      name.rpartition('::')[2]
    end

    # Reads the file the class that extends this module is in.
    #
    # @return [String] The file's contents.
    # @private
    def read_class_file
      path = defined_methods.first[0]
      File.read(path)
    end

    # Gets all the methods a class has that are not inherited.
    #
    # @return [Array] The source locations of every method in the class.
    # @private
    def defined_methods
      methods = methods(false).map { |m| method(m) }
      methods += instance_methods(false).map { |m| instance_method(m) }
      methods.map!(&:source_location)
      methods.compact
    end
  end
end
