module SelectiveProtection
  module AssociationHelpers
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        proxy_block :with_accessible
      end
    end

    module InstanceMethods

      def with_accessible(*attrs)
        @reflection.klass.send(:with_accessible, *attrs) { yield }
      end

    end
  end
end