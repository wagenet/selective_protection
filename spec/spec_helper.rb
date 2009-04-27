ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment')
require 'spec/autorun'
require 'spec/rails'

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

class Columnless < ActiveRecord::Base
  def self.columns; []; end # Avoid having a db table
end