require 'simplecov'
require 'simplecov-vim/formatter'
require 'codeclimate-test-reporter'
require 'simple_docx_generator'
CodeClimate::TestReporter.start
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::VimFormatter,
  CodeClimate::TestReporter::Formatter
]
