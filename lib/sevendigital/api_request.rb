module Sevendigital

class ApiRequest

  attr_reader :api_method, :parameters, :signed
  attr_accessor :token, :api_service
  attr_accessor :signature_scheme

  def initialize(api_method, parameters, options={})
    @api_method = api_method
    @parameters = parameters
    @signature_scheme = :header
    comb_parameters
  end

  def requires_signature?
    @signed == true
  end

  def require_signature
    @signed = true
  end

  def requires_secure_connection?
    @secure == true
  end

  def require_secure_connection
    @secure = true
  end

  def comb_parameters
    parameters = @parameters
    page_size = parameters[:page_size] || parameters[:per_page]
    parameters.delete(:page_size)
    parameters[:pageSize] ||= page_size if page_size

    shop_id = parameters[:shop_id]
    parameters.delete(:shop_id)
    parameters[:shopId] ||= shop_id if shop_id

    parameters = remove_nils(parameters)
    @parameters = parameters
  end

  def remove_nils(parameters)
    parameters.delete_if { |key, value| value.nil? }
  end


end

end