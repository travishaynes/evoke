# Evoke

[![GitHub version](https://badge.fury.io/gh/travishaynes%2Fevoke.svg)](http://badge.fury.io/gh/travishaynes%2Fevoke)
[![Build Status](https://travis-ci.org/travishaynes/evoke.svg)](https://travis-ci.org/travishaynes/evoke)
[![Code Climate](https://codeclimate.com/github/travishaynes/evoke/badges/gpa.svg)](https://codeclimate.com/github/travishaynes/evoke)
[![Test Coverage](https://codeclimate.com/github/travishaynes/evoke/badges/coverage.svg)](https://codeclimate.com/github/travishaynes/evoke)
[![Inline docs](http://inch-ci.org/github/travishaynes/evoke.svg)](http://inch-ci.org/github/travishaynes/evoke)

A lightweight, zero-dependency task tool for Ruby.

## Installation

    $ gem install evoke

## Usage

### Writing Tasks

Evoke tasks are Ruby classes that look like this:

```ruby
# Prints a friendly message to the console.
#
# This comment actually does something. The first line is used as a short
# description when `evoke help` or `evoke` is called without any arguments.
# The rest of the comment is printed, along with the first line, when
# `evoke help hello_world` is called to pull up help about this specific task.
class HelloWorld < Evoke::Task

  # The initializer of an Evoke::Task cannot have any required parameters.
  def initialize
  end

  # Called when this method is invoked on the command-line. This task would be
  # invoked using `evoke hello_world`.
  def invoke
    puts "Hello world!"
  end
end
```

#### Namespacing

Tasks are namespaced using modules. Their command names are underscored from
their Ruby class names. For example, a task named `Example::HelloWorld` would be
invoked on the command line with `evoke example/hello_world`.

#### Command-Line Arguments

Here's an example of a task that uses command-line arguments and is namespaced.

```ruby
module Math
  class Add < Evoke::Task
    # This can be used as an alternative to providing the short description in
    # the class comment.
    desc "Adds two integers and prints the result in the console"

    # All parameters come through as strings since they are read from the
    # arguments supplied on the command-line.
    def invoke(a, b)
      puts a.to_i + b.to_i
    end
  end
end
```

This task would be invoked from the command-line with `evoke math/add 5 10`,
where a=5 and b=10 in this example.

#### Optional Arguments

Variable-assigned optional parameters are supported. Key based, `&block` and
`*` parameters are not and will raise an error.

```ruby
# SUPPORTED
def invoke(req, opt='optional argument'); end

# NOT SUPPORTED - errors will be raised
def invoke(opt: 'optional argument'); end
def invoke(*args); end
def invoke(&block); end
```


#### Named Arguments

Environment variables are used for named arguments. Make sure to document the
required environment variables in the class comment of the task, perhaps even
including some examples. Normal parameters are displayed in the tasks' help,
environment variables are not.

Here's an example of the `math/add` task from earlier using named arguments that
is well documented:

```ruby
module Math
  # Adds two integers and prints the result in the console.
  #
  # Two environment variables are required to use this task: A and B.
  #
  # == Example: Adding 5 and 10.
  #
  #     evoke math/add A=5 B=10
  #
  # == Example: Adding 2 and 3.
  #
  #     evoke math/add A=2 B=3
  #
  class Add < Evoke::Task

    def initialize
      @a = ENV['A'].to_i
      @b = ENV['B'].to_i
    end

    def invoke
      puts @a + @b
    end
  end
end
```

#### Documenting Tasks

Using `evoke help` will give the user a more detailed description on how to use
the task. Providing this description is as easy as adding a comment to the
task's class. For example:

```ruby
# Prints the sum of two integers.
#
# This is a completely useless task that allows you to add two numbers together
# in the console using Evoke, a command-line task tool for Ruby.
#
# To use the task provide two integers via `evoke add A B`, where A and B are
# the integers. For example: `evoke add 1 5` will result in the number 6 being
# printed to the console. How completely pointless is that?
#
# This comment is displayed for this task when you run `evoke help add`.
class Add < Evoke::Task
  def invoke(a, b)
    puts a.to_i + b.to_i
  end
end
```

Alternately, you can use the `#syntax` and `#desc` class methods, which will
take precedence over the class comment.

```ruby
# This class comment will not be used to display help for this task because both
# the short and long descriptions are provided using #desc and #syntax.
#
# If only the #syntax method was used, the first line of this comment would
# still be used for the short description, and vice-versa. Both methods need to
# be used to completely disregard this comment.
class Add < Evoke::Task
  desc "Prints the sum of two integers."
  syntax "Provide two integers as arguments to this task."

  def invoke
    puts a.to_i + b.to_i
  end
end
```

### Loading Tasks

There are two ways tasks can be loaded.

1. Place the tasks in the working directory's lib/tasks folder and end the file
names with `_task.rb`.
2. Create a file named `evoke.rb` and load the tasks manually or place them
directly in that file.

Running `evoke` from the command line will scan the current working directory.
It will first search for a file named `evoke.rb`. If found, Evoke will assume
this file takes care of loading the tasks. Otherwise the `lib/tasks` folder will
be recursively searched for `_task.rb` files, which will be loaded in the order
they are found.

Here's an example `evoke.rb` file for using Evoke with a Rails application:

```ruby
# Searches the lib/evoke folder for _task.rb files and loads them.
Evoke.load_tasks('lib/evoke')

# Load the Rails environment before a task is invoked.
Evoke.before_task do |task, *args|
  require File.expand_path("../config/environment.rb", __FILE__)
end
```

Note that the Rails environment is loaded in a #before_task callback. This makes
sure that the environment only loads when the task is actually being invoked,
and not when the user is simply trying to list the available tasks or made a
mistake in the task's name or arguments.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. [Fork it](https://github.com/travishaynes/evoke/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
