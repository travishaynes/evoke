# Evoke

A lightweight, zero-dependency task tool for Ruby.

## Installation

    $ gem install evoke

## Usage

### Writing Tasks

Evoke tasks are Ruby classes that look like this:

```ruby
class HelloWorld < Evoke::Task
  # This description appears when your run `evoke` without any arguments.
  desc "Prints a friendly message"

  # This method is called by Evoke when the task is executed.
  def invoke
    puts "Hello world!"
  end
end
```

**Important:** Initializers for Evoke::Tasks cannot have any required arguments.

This task would be invoked from the command-line with `evoke hello_world`.

#### Namespacing

Tasks are namespaced using modules. Their command names are underscored from
their Ruby class names. For example, a task named `Example::HelloWorld` would be
invoked on the command line with `evoke example/hello_world`.

#### Command-line-arguments

Here's an example of a task that uses command-line arguments and is namespaced.

```ruby
module Math
  class Add < Evoke::Task
    desc "Adds two integers and prints the result in the console"

    def invoke(a, b)
      puts a.to_i + b.to_i
    end
  end
end
```

**Note:** All arguments come through as strings since they are read from the
command-line.

This task would be invoked from the command-line with `evoke math/add 5 10`,
where a=5 and b=10 in this example.

Switches are not currently supported. Use environment variables to use named
arguments. Here's the same example as above using environment variables:

```ruby
module Math
  class Add < Evoke::Task
    desc "Adds two integers and prints the result in the console"

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

This task would be invoked from the command-line with `evoke math/add A=5 B=10`.

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
