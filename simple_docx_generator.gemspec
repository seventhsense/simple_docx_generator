# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_docx_generator/version'

Gem::Specification.new do |gem|
  gem.name          = "simple_docx_generator"
  gem.version       = SimpleDocxGenerator::VERSION
  gem.authors       = ["seventhsense"]
  gem.email         = ["seventh@scimpr.com"]
  gem.description   = %q{テンプレートdocxに値を代入して新しいdocxファイルを生成します。}
  gem.summary       = %q{テンプレートdocxに値を代入して新しいdocxファイルを生成します。}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "nokogiri", "1.6.8.1"
  gem.add_runtime_dependency "rubyzip" , "1.2.0"
  gem.add_runtime_dependency "rmagick" , "2.16.0"
  gem.add_runtime_dependency "htmlentities" , "4.3.4"
  gem.add_runtime_dependency "ydocx" , "1.2.5"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "simplecov-vim"
  gem.add_development_dependency "codeclimate-test-reporter"
end
