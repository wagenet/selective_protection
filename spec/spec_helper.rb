ENV["RAILS_ENV"] = "test"
require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'environment')

require 'spec/autorun'
require 'spec/rails'