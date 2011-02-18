module Sevendigital

  #@private
  class UserDigestor < Digestor # :nodoc:

    def default_element_name; :user end
    
    def from_proxy(user_proxy)
      make_sure_not_eating_nil(user_proxy)

      user = User.new(@api_client)
      user.id = user_proxy.id.to_s  if !user_proxy.nil?
      user.type = user_proxy.type.value.to_sym
      user.email_address = user_proxy.email_address.value.to_s if value_present?(user_proxy.email_address)

      return user
    end

  end

end