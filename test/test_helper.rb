require_relative 'support/coverage'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'evoke'
require 'minitest/autorun'

require_relative 'support/fixtures'
require_relative 'support/output_mocks'
