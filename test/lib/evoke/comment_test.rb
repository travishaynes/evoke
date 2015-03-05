require 'test_helper'

module Evoke
  class CommentTest < Minitest::Test
    def teardown
      Object.send(:remove_const, :Fixtures) if defined?(Fixtures)
    end

    def test_class_comment
      Evoke.load_tasks("test/fixtures/lib/tasks")

      comment = <<-EOF.split("\n").map(&:strip).join("\n")
        This is an example task that is used in testing. It's used to test that
        Evoke.load_tasks works properly and that Evoke::Comment can extract this
        comment from the file.
      EOF

      assert_equal comment, Fixtures::ExampleTask.class_comment
      assert_equal "", Fixtures::NilDescTask.class_comment
    end
  end
end
