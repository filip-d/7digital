module Sevendigital

class ApiRequest

  attr_reader :api_method, :parameters, :signed
  attr_accessor :token, :api_service, :http_method
  attr_accessor :signature_scheme

  def initialize(api_method, parameters, options={})
    @api_method = api_method
    @parameters = parameters
    @signature_scheme = :header
    @http_method = :GET
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
    comb_parameter(:pageSize, [:page_size, :per_page])
    comb_parameter(:shopId, :shop_id)
    comb_parameter(:imageSize, :image_size)
    remove_empty_parameters()
  end

  def comb_parameter(correct_name, alternative_names)
    param_value = nil
    alternative_names = [alternative_names] unless alternative_names.is_a?(Array)
    alternative_names.each do |alternative_name|
      param_value ||= @parameters[alternative_name]
      @parameters.delete(alternative_name)
    end
    @parameters[correct_name] ||= param_value if param_value
  end

  def remove_empty_parameters
    @parameters.delete_if { |key, value| value.nil? }
  end


end

end