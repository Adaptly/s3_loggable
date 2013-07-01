# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "s3_loggable/version"

Gem::Specification.new do |s|
  s.name          = "s3_loggable"
  s.version       = S3Loggable::VERSION
  s.authors       = ["Will Highducheck"]
  s.email         = ["will.highducheck@gmail.com"]
  s.summary       = "S3Loggable"
  s.description   = "Simple logging to S3"
  s.homepage      = "http://github.com/adaptly/s3_loggable"

  s.add_development_dependency "rake"
  s.add_development_dependency "mocha", "~> 0.14"

  s.add_dependency "fog", "~> 1.12"

  s.post_install_message = "Something clever about logs.  Hahahaha..."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
end
