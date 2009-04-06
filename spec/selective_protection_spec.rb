require File.join(File.dirname(__FILE__), 'spec_helper')

class SelectivelyProtected < ActiveRecord::Base
  def self.columns; []; end # Avoid having a db table
  
  attr_accessor :dangerous, :safe
end

class BlacklistProtected < SelectivelyProtected
  attr_protected :dangerous
end

class WhilelistProtected < SelectivelyProtected
  attr_accessible :safe
end

describe SelectivelyProtected do

  specify { SelectivelyProtected.should include(SelectiveProtection::Extensions) }

  it "should have normally accessible attributes" do
    sp = SelectivelyProtected.new(:dangerous => "dangerous", :safe => "safe")
    sp.dangerous.should == "dangerous"
    sp.safe.should == "safe"
  end

  [BlacklistProtected, WhilelistProtected].each do |klass|
    
    describe klass do
    
      it "should not allow access to dangerous" do
        sp = klass.new(:dangerous => "dangerous", :safe => "safe")
        sp.dangerous.should be_nil
        sp.safe.should == "safe"
      end
  
      it "should allow access to dangerous when using with_accessible" do
        sp = klass.with_accessible(:dangerous) do
          klass.new(:dangerous => "dangerous", :safe => "safe")
        end
        sp.dangerous.should == "dangerous"
        sp.safe.should == "safe"
      end
  
      it "should support proxy format" do
        sp = klass.with_accessible(:dangerous).new(:dangerous => "dangerous", :safe => "safe")
        sp.dangerous.should == "dangerous"
        sp.safe.should == "safe"
      end
    
    end
  end
end