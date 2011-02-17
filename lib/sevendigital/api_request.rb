module Sevendigital

#@private
#Abstraction of a HTTP API request, ApiOperator uses this ApiRequest to build a real HTTP requests
class ApiRequest # :nodoc:

  attr_reader :api_method, :parameters, :signed
  attr_accessor :token, :api_service, :http_method
  attr_accessor :signature_scheme
  attr_writer :form_parameters

  def initialize(http_method, api_method, parameters, options={})
    @api_method = api_method
    @parameters = parameters
    @signature_scheme = :header
    @http_method = http_method
    comb_parameters(parameters)
    @form_parameters = Hash.new
  end

  def form_parameters
    comb_parameters(@form_parameters)
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

  def comb_parameters(parameters)
    comb_parameter(parameters, :pageSize, [:page_size, :per_page])
    comb_parameter(parameters, :shopId, :shop_id)
    comb_parameter(parameters, :imageSize, :image_size)
    remove_empty_parameters(parameters)
    parameters
  end

  def comb_parameter(parameters, correct_name, alternative_names)
    param_value = nil
    alternative_names = [alternative_names] unless alternative_names.is_a?(Array)
    alternative_names.each do |alternative_name|
      param_value ||= parameters[alternative_name]
      parameters.delete(alternative_name)
    end
    parameters[correct_name] ||= param_value if param_value
  end

  def remove_empty_parameters(parameters)
    parameters.delete_if { |key, value| value.nil? }
  end


end

end