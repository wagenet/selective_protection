module SelectiveProtection
  module WithAccessible
    def self.included(base)
      base.send :extend, ClassMethods
      class << base; proxy_block :with_accessible; end
    end

    module ClassMethods

      def with_accessible(*attrs)
        raise ArgumentError.new("Must provide a list of accessible attributes") if attrs.empty?

        allow_all = (attrs == [:all])

        orig_protected_attributes = protected_attributes
        orig_accessible_attributes = accessible_attributes

        protected_name, accessible_name = Rails.version.starts_with?('2.1') ?
          ['attr_protected', 'attr_accessible'] : [:attr_protected, :attr_accessible]

        if !protected_attributes.nil?
          new_columns = allow_all ? [] : (orig_protected_attributes - attrs.map(&:to_s))
          write_inheritable_attribute(protected_name, new_columns)
        elsif !accessible_attributes.nil?
          new_columns = allow_all ? column_names : (orig_accessible_attributes | attrs.map(&:to_s))
          write_inheritable_attribute(accessible_name, new_columns)
        end

        yield
      ensure
        write_inheritable_attribute(protected_name, orig_protected_attributes)
        write_inheritable_attribute(accessible_name, orig_accessible_attributes)
      end

    end
  end
end