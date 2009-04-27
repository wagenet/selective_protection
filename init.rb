require 'proxy_block'

ActiveRecord::Base.send :include, SelectiveProtection::WithAccessible
ActiveRecord::Associations::AssociationProxy.send :include, SelectiveProtection::AssociationHelpers