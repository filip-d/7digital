module Sevendigital

  #@private
  #internal generic class used for digesting XML responses from the API
  class Digestor # :nodoc:

      #TODO TEST THIS CRAP

      def initialize(api_client)
        @api_client = api_client
      end

      def from_xml(xml_or_proxy, element_name = default_element_name)
        return from_proxy(ProxyPolice.ensure_is_proxy(xml_or_proxy, element_name))
      end

      def from_xml_nokogiri(xml, element_name = default_element_name)
        xml_doc = Nokogiri::XML(xml)
        from_xml_doc(xml_doc.at_xpath("./#{element_name}"))
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

      def list_from_xml_nokogiri(xml, list_element_name = default_list_element_name)
         xml_doc = Nokogiri::XML(xml)
         list_from_xml_doc(xml_doc.at_xpath("./#{list_element_name}"))
       end

       def list_from_xml_doc(list_node)
         make_sure_eating_nokogiri_node(list_node)
         list = []
         list_node.xpath("./#{default_element_name}").each { |node| list << from_xml_doc(node)}
         paginate_results_nokogiri(list_node, list)
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

      def paginate_results_nokogiri(xml_results, list)
        pager = @api_client.pager_digestor.from_xml_doc(xml_results)
        return list if !pager
        pager.paginate_list(list)
      end

      def make_sure_not_eating_nil(xml)
        raise DigestiveProblem, "There's nothing i can digest" unless xml
      end

      def make_sure_eating_nokogiri_node(xml)
        raise DigestiveProblem, "There's nothing i can digest" unless xml
        raise DigestiveProblem, "I'm not eating this! It's not a Nokogiri XML node.'" unless xml.kind_of?(Nokogiri::XML::Node)
      end

      def value_present?(proxy_node)
        !proxy_node.nil? &&  !proxy_node.value.nil? && !proxy_node.value.empty?
      end

      def content_present?(proxy_node)
        !proxy_node.nil?
      end

      def get_optional_value(node, element_name)
        if node.at_xpath("./#{element_name}") then
          content = node.at_xpath("./#{element_name}").content
          return yield(content) if block_given?
          return content
        end
        nil
      end

      def get_optional_node(node, element_name)
        if node.at_xpath("./#{element_name}") then
          subnode = node.at_xpath("./#{element_name}")
          return yield(subnode) if block_given?
          return subnode
        end
        nil
      end

  end

  class DigestiveProblem < StandardError;  end

end
