require 'proxy_block'
module SelectiveProtection
  module Extensions
    def self.included(base)
      base.send :extend, ClassMethods
      class << base; proxy_block :with_accessible; end
    end
  
    module ClassMethods
    
      def with_accessible(*attrs)
        orig_protected_attributes = protected_attributes
        orig_accessible_attributes = accessible_attributes
  
        if !protected_attributes.nil?
          write_inheritable_attribute(:attr_protected, orig_protected_attributes - attrs.map(&:to_s))
        elsif !accessible_attributes.nil?
          write_inheritable_attribute(:attr_accessible, orig_accessible_attributes | attrs.map(&:to_s))
        end
  
        yield
      ensure
        write_inheritable_attribute(:attr_protected, orig_protected_attributes)
        write_inheritable_attribute(:attr_accessible, orig_accessible_attributes)
      end

    end
  end
  
end

ActiveRecord::Base.send :include, SelectiveProtection::Extensions