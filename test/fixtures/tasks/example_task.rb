module Fixtures

  # This is an example task that is used in testing. It's used to test that
  # Evoke.load_tasks works properly and that Evoke::Comment can extract this
  # comment from the file.
  class ExampleTask < Evoke::Task
    desc "Prints a friendly message to STDOUT"

    def invoke(message="Hello World")
      puts message
    end
  end
end
