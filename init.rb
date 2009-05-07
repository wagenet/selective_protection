if Rails.version >= '2.1' && Rails.version < '3'
  require 'proxy_block'

  ActiveRecord::Base.send :include, SelectiveProtection::WithAccessible
  ActiveRecord::Associations::AssociationProxy.send :include, SelectiveProtection::AssociationHelpers
else
  puts "selective_protection requires Rails >= 2.1 and < 3"
end