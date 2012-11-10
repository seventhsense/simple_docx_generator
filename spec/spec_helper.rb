require 'simplecov'
require 'simplecov-vim/formatter'
SimpleCov.start do
  formatter SimpleCov::Formatter::VimFormatter
end
require 'simple_docx_generator'
