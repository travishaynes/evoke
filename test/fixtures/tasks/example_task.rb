module Fixtures
  class ExampleTask < Evoke::Task
    desc "Prints a friendly message to STDOUT"

    def invoke(message="Hello World")
      puts message
    end
  end
end
