$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cacheable_kdtree'
require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.minimum_coverage 80
SimpleCov.start
require 'minitest/autorun'
require 'mocha/mini_test'
