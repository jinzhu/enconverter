# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "enconverter"
  gem.homepage = "http://github.com/jinzhu/enconverter"
  gem.license = "MIT"
  gem.summary = %Q{Encoding Converter, rack middleware used to convert to encoding}
  gem.description = %Q{Encoding Converter, rack middleware used to convert to encoding}
  gem.email = "wosmvp@gmail.com"
  gem.authors = ["Jinzhu"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
