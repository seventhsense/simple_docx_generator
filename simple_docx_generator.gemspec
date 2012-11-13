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

  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "zipruby"
  gem.add_runtime_dependency "rubyzip" 
  gem.add_runtime_dependency "rmagick" 
  gem.add_runtime_dependency "htmlentities" 
  gem.add_runtime_dependency "ydocx" 
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "simplecov-vim"
end
