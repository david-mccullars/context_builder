require 'rspec'
require 'simplecov'
require 'simplecov-rcov'
SimpleCov.start
SimpleCov.formatter = Class.new do
  def format(result)
     SimpleCov::Formatter::HTMLFormatter.new.format(result)
     SimpleCov::Formatter::RcovFormatter.new.format(result)
  end
end
