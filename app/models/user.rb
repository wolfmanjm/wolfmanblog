require 'merb-auth-more/mixins/salted_user'
class User < Sequel::Model
  include Merb::Authentication::Mixins::SaltedUser
end
