module SelectiveProtection
  module Extensions
    def self.included(base)
      base.send :extend, ClassMethods
    end
  
    module ClassMethods
    
      def with_accessible(*attrs, &block)
        if block_given?
          with_accessible_wrapper(*attrs, &block)
        else
          SelectiveProtection::Proxy.new(self, attrs)
        end
      end
      
      private
      
        def with_accessible_wrapper(*attrs)
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
  
  class Proxy
    
    alias :proxy_instance_eval :instance_eval
    alias :proxy_extend :extend

    # Make sure the proxy is as dumb as it can be.
    # Blatanly taken from Jim Wierich's BlankSlate post:
    # http://onestepback.org/index.cgi/Tech/Ruby/BlankSlate.rdoc
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^proxy_)/ }
    
    def initialize(object, attrs)
      @object = object
      @attrs = attrs
    end
    
    def proxy_object; @object; end
    def proxy_attrs; @attrs; end
    
    def method_missing(sym, *args, &block)
      proxy_object.send(:with_accessible_wrapper, proxy_attrs){ proxy_object.send(sym, *args, &block) }
    end
    
  end
end

ActiveRecord::Base.send :include, SelectiveProtection::Extensions