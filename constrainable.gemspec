# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.name        = "constrainable"
  s.summary     = "Simple filtering for ActiveRecord"
  s.description = "Sanitizes simple and readable query parameters -great for building APIs & HTML filters"
  s.version     = '0.5.1'

  s.authors     = ["Dimitrij Denissenko"]
  s.email       = "dimitrij@blacksquaremedia.com"
  s.homepage    = "https://github.com/bsm/constrainable"

  s.require_path = 'lib'
  s.files        = Dir['LICENSE', 'README.markdown', 'lib/**/*']

  s.add_dependency "abstract"
  s.add_dependency "activerecord", ">= 3.0.0"
  s.add_dependency "activesupport", ">= 3.0.0"
end
