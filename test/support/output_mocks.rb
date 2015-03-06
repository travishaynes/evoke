# Supplies methods that can be used to mock $stdout and $stderr.
module OutputMocks
  protected

  # Mocks $stdout with a StringIO instance. The puts and print methods will
  # write to that instead of the console.
  def mock_stdout
    @original_stdout ||= $stdout
    $stdout = StringIO.new
  end

  # Mocks $stderr with a StringIO instance.
  def mock_stderr
    @original_stderr ||= $stderr
    $stderr = StringIO.new
  end

  # Restores the original $stdout.
  def restore_stdout
    $stdout = @original_stdout unless @original_stdout.nil?
  end

  # Restores the original $stderr.
  def restore_stderr
    $stderr = @original_stderr unless @original_stderr.nil?
  end

  # Sets $stdout to an empty string.
  def clear_stdout
    $stdout.string = '' if $stdout.is_a?(StringIO)
  end

  # Sets $stderr to an empty string.
  def clear_stderr
    $stderr.string = '' if $stderr.is_a?(StringIO)
  end
end

# Add output mock support to Minitest
Minitest::Test.send(:include, OutputMocks)
