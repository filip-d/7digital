module Sevendigital

  #internal generic class used for digesting XML responses from the API
  class Digestor # :nodoc:

      #TODO TEST THIS CRAP

      def initialize(api_client)
        @api_client = api_client
      end

      def from_xml(xml_or_proxy, element_name = default_element_name)
        return from_proxy(ProxyPolice.ensure_is_proxy(xml_or_proxy, element_name))
      end

      def list_from_xml(xml_or_proxy, list_element_name = default_list_element_name)
        list_from_proxy(ProxyPolice.ensure_is_proxy(xml_or_proxy, list_element_name))
      end

      def list_from_proxy(object_list_proxy)
        make_sure_not_eating_nil(object_list_proxy)
        list = []
        return list if object_list_proxy.kind_of?(Peachy::SimpleContent)
        if object_list_proxy.send(default_element_name) then
          object_list_proxy.send(default_element_name).each { |object_proxy| list << from_proxy(object_proxy) }
        end
        paginate_results(object_list_proxy, list)
      end

      #nested parsing for api methods that return standard object inside containers with no additional (useful) information
      #e.g. tagged_item.artist, recommendation.release, search_result.track, etc

      def nested_list_from_xml(xml_or_proxy, container_element_name, list_element_name = default_list_element_name)
        nested_list_from_proxy(ProxyPolice.ensure_is_proxy(xml_or_proxy, list_element_name), container_element_name)
      end

      def nested_list_from_proxy(object_list_proxy, container_element_name)
        make_sure_not_eating_nil(object_list_proxy)
        list = []
        if object_list_proxy.send(container_element_name) then
          object_list_proxy.send(container_element_name).each do
            |object_proxy| list << from_proxy(object_proxy.send(default_element_name))
          end 
        end
        return paginate_results(object_list_proxy, list)
      end

      def paginate_results(xml_results, list)
        pager = @api_client.pager_digestor.from_xml(xml_results)
        return list if !pager
        pager.paginate_list(list)
      end

      def make_sure_not_eating_nil(proxy)
        raise DigestiveProblem, "There's nothing i can digest" unless proxy
      end

      def value_present?(proxy_node)
        !proxy_node.nil? &&  !proxy_node.value.nil? && !proxy_node.value.empty?
      end

      def content_present?(proxy_node)
        !proxy_node.nil?
      end

  end

  class DigestiveProblem < StandardError;  end

end
