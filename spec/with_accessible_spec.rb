require File.join(File.dirname(__FILE__), 'spec_helper')

class SelectivelyProtected < Columnless
  attr_accessor :harmful, :dangerous, :safe
end

class BlacklistProtected < SelectivelyProtected
  attr_protected :dangerous, :harmful
end

class WhilelistProtected < SelectivelyProtected
  attr_accessible :safe
end

describe SelectiveProtection::WithAccessible do

  specify { SelectivelyProtected.should include(SelectiveProtection::WithAccessible) }

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

      it "should return to normal behavior" do
        sp = klass.with_accessible(:dangerous).new(:dangerous => "dangerous", :safe => "safe")
        sp.dangerous.should == "dangerous"
        sp.safe.should == "safe"

        sp2 = klass.new(:dangerous => "dangerous", :safe => "safe")
        sp2.dangerous.should be_nil
        sp2.safe.should == "safe"
      end

      it "should not allow setting of attributes not explicitly allowed" do
        sp = klass.with_accessible(:dangerous).new(:harmful => "harmful", :dangerous => "dangerous", :safe => "safe")
        sp.harmful.should be_nil
        sp.dangerous.should == "dangerous"
        sp.safe.should == "safe"
      end

    end
  end
end