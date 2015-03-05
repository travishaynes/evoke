require_relative 'coverage/code_climate'

# Use Code Climate's coverage if the token is available. If not, fall back to
# SimpleCov for local code coverage generation.
if ENV['CODECLIMATE_REPO_TOKEN']
  CodeClimate::TestReporter.start
else
  require_relative 'coverage/simplecov'
end
