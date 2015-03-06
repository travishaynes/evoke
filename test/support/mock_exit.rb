# Extend this module to override the default #exit method to prevent the
# application from actually exiting.
module MockExit
  attr_reader :exit_code

  def exit(code)
    @exit_code = code
  end
end
