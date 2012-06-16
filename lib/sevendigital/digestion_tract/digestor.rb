module Sevendigital

  #@private
  #internal generic class used for digesting XML responses from the API
  class Digestor # :nodoc:

      #TODO TEST THIS CRAP

      def initialize(api_client)
        @api_client = api_client
      end

      def from_xml_string(xml, element_name = default_element_name)
        xml_doc = Nokogiri::XML(xml)
        from_xml_doc(xml_doc.at_xpath("./#{element_name}"))
      end

      def list_from_xml_string(xml, list_element_name = default_list_element_name)
         xml_doc = Nokogiri::XML(xml)
         list_from_xml_doc(xml_doc.at_xpath("./#{list_element_name}"))
       end

       def list_from_xml_doc(list_node)
         make_sure_eating_nokogiri_node(list_node)
         list = []
         list_node.xpath("./#{default_element_name}").each { |node| list << from_xml_doc(node)}
         paginate_results(list_node, list)
       end

      #nested parsing for api methods that return standard object inside containers with no additional (useful) information
      #e.g. tagged_item.artist, recommendation.release, search_result.track, etc

      def nested_list_from_xml_string(xml, container_element_name, list_element_name = default_list_element_name)
        xml_doc = Nokogiri::XML(xml)
        nested_list_from_xml_doc(xml_doc.at_xpath("./#{container_element_name}"), list_element_name)
      end

      def nested_list_from_xml_doc(list_node, list_element_name = default_list_element_name, element_name = default_element_name)
        puts list_element_name
        puts element_name
        puts list_node.inspect
        make_sure_eating_nokogiri_node(list_node)
        list = []
        list_node.xpath("./#{list_element_name}/#{element_name}").each { |node| list << from_xml_doc(node)}
        paginate_results(list_node, list)
      end

      def paginate_results(results_xml_node, list)
        pager = @api_client.pager_digestor.from_xml_doc(results_xml_node)
        return list if !pager
        pager.paginate_list(list)
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

      def get_required_value(node, element_name)
        if node.at_xpath("./#{element_name}") then
          content = node.at_xpath("./#{element_name}").content
          return yield(content) if block_given?
          return content
        end
        raise DigestiveProblem, "I need #{element_name} element to digest the response"
      end

      def get_required_node(node, element_name)
        if node.at_xpath("./#{element_name}") then
          subnode = node.at_xpath("./#{element_name}")
          return yield(subnode) if block_given?
          return subnode
        end
        raise DigestiveProblem, "I need #{element_name} element to digest the response"
      end

      def get_required_attribute(node, attribute_name)
        if node.at_xpath("@#{attribute_name}") then
          content = node.at_xpath("@#{attribute_name}").content
          return yield(content) if block_given?
          return content
        end
        raise DigestiveProblem, "I need #{attribute_name} attribute to digest the response"
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

      def get_optional_attribute(node, attribute_name)
        if node.at_xpath("@#{attribute_name}") then
          content = node.at_xpath("@#{attribute_name}").content
          return yield(content) if block_given?
          return content
        end
        nil
      end

  end

  class DigestiveProblem < StandardError;  end

end
