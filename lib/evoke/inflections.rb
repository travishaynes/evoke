module Evoke
  # Inflections define new methods on the String class to transform names for
  # different purposes.
  module Inflections
    # Load the inflections.
    inflections_path = File.expand_path('../inflections/*.rb', __FILE__)
    Dir[inflections_path].each { |f| require f }

    # Add the inflections to the String class.
    constants.each { |i| String.send(:include, const_get(i)) }
  end
end
