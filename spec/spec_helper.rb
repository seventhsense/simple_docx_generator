require 'simplecov'
require 'simplecov-vim/formatter'
require 'codeclimate-test-reporter'
SimpleCov.start do
  formatter SimpleCov::Formatter::VimFormatter
end
# SimpleCov.start
CodeClimate::TestReporter.start
require 'simple_docx_generator'
