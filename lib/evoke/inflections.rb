module Evoke::Inflections; end

require 'evoke/inflections/camelize'
require 'evoke/inflections/underscore'

String.send(:include, Evoke::Inflections::Camelize)
String.send(:include, Evoke::Inflections::Underscore)
