require 'simplecov'
require 'simplecov-vim/formatter'
require 'codeclimate-test-reporter'
require 'simple_docx_generator'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
]
SimpleCov.start do
  add_filter '/lib/'
end
