require File.join(File.dirname(__FILE__), 'spec_helper')

class SPParent < Columnless
  has_many :children, :class_name => "SPChild"

  attr_accessor :dangerous, :safe
  attr_protected :dangerous
end

class SPChild < Columnless
  belongs_to :parent, :class_name => "SPParent"

  attr_accessor :dangerous, :safe
  attr_protected :dangerous
end

describe SelectiveProtection::AssociationHelpers do

  #specify { ActiveRecord::Associations::AssociationProxy.should include(SelectiveProtection::AssociationHelpers) }

  describe "associations" do

    before(:each) do
      @parent = SPParent.new
    end

    it "should now allow accessing of protected" do
      c = @parent.children.build(:dangerous => "dangerous", :safe => "safe")
      c.dangerous.should be_nil
      c.safe.should == "safe"
    end

    it "should have with_accessible method" do
      c = @parent.children.with_accessible(:dangerous){ @parent.children.build(:dangerous => "dangerous", :safe => "safe") }
      c.dangerous.should == "dangerous"
      c.safe.should == "safe"
    end

    it "should have with_accessible proxy" do
      c = @parent.children.with_accessible(:dangerous).build(:dangerous => "dangerous", :safe => "safe")
      c.dangerous.should == "dangerous"
      c.safe.should == "safe"
    end
  end

end