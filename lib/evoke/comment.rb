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
module Evoke::Comment
  # Extracts the comment prefixing a class.
  #
  # @return [String] The class' comment.
  def class_comment
    start_line, lines = start_index_and_code_lines

    comment = []

    (start_line-1).downto(0).each {|i|
      line = lines[i].strip

      if line.start_with?(?#)
        comment << line[1..line.length].strip
      elsif comment != ""
        break
      end
    }

    comment.reverse.join("\n")
  end

  private

  # Gets the lines in the class file and the line number that the class is
  # actually defined.
  #
  # @param [Array] The start position is first, followed by the code lines.
  # @private
  def start_index_and_code_lines
    data = read_class_file
    pos = data =~ /class.*\s*#{simple_name}.*\s*\<\s*Evoke::Task/
    [data[0..pos].count("\n"), data.split("\n")]
  end

  # The name of the class without a namespace.
  #
  # @return [String] The class' simple name.
  # @private
  def simple_name
    self.name.rpartition("::")[2]
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
    methods = methods(false).map {|m| method(m) }
    methods += instance_methods(false).map {|m| instance_method(m) }
    methods.map!(&:source_location)
    methods.compact
  end
end
