# Adds support to read fixtures in Minitest::Test cases.
module FixtureSupport
  protected

  # Reads a fixture from test/fixtures.
  #
  # @param [String] name The relative path to the fixture file.
  # @return [String] The fixture's contents.
  def read_fixture(name)
    root = File.expand_path('../../fixtures', __FILE__)
    path = File.join(root, name)
    File.read(path)
  end
end

Minitest::Test.send(:include, FixtureSupport)
