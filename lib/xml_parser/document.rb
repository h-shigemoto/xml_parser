require "rexml/document"
require "yaml"
require "pp"

# XML Parser module
module XmlParser

  # Document Class
  class Document

    # constructor.
    # @param [String / REXML::Document] xml xml string / REXML::Document object.
    def initialize(xml)

      # xml string
      if xml.is_a?(String)
        @doc = REXML::Document.new(xml)
      # REXML::Document object
      elsif xml.is_a?(REXML::Document)
        @doc = xml
      else
        raise TypeError.new("XmlParser::Document initialize error.")
      end
    end

    # if xpath match, do map process.
    # if block_given? == false, return xpath match values.
    # @param [String] xpath xpath
    # @return [Array] match value by Array.
    def xpath_map(xpath)

      matches = REXML::XPath.match(@doc, xpath)
      return matches unless block_given?

      # if block_given, do map process.
      matches.map { |elm|
        yield elm
      }
    end

    # if xpath match, do each process.
    # if block_given? == false, display each element by pp. Use confirm xpath.
    # @param [String] xpath xpath
    def xpath_each(xpath)

      REXML::XPath.match(@doc, xpath).each { |elm|
        if block_given?
          yield elm
        else
          pp elm
        end
      }
    end

    # xml decl info.
    # @return [REXML::XMLDecl] xml decl
    def decl
      @doc.xml_decl
    end

    # get document.
    # @return [REXML::Document] document
    def document
      @doc
    end

    # initialize from File.
    # @param [String] filepath read fileptah. absolute.
    # @return [XmlParser::Document] parser.
    def self.from_file(filepath)

      # read file contents.
      xml_str = File.read(filepath)
      XmlParser::Document.new(xml_str)
    end

    # initialize from yml file.
    # @param [String] filepath read yml filepath. absolute.
    # @param [String] root_name root element name
    # @param [String] attr_name attribute name
    # @return [XmlParser::Document] parser
    def self.from_yml(filepath, root_name="root", attr_name="value")

      # load yml file.
      yml = YAML.load_file(filepath)
      # parse to xml.
      parse_xml_from_hash(yml, root_name, attr_name)
    end

    # initialize from hash
    # @param [Hash] hash hash
    # @param [String] root_name root element name
    # @param [String] attr_name attribute name
    # @return [XmlParser::Document] parser
    def self.from_hash(hash, root_name="root", attr_name="value")

      parse_xml_from_hash(hash, root_name, attr_name)
    end

    private

    # parse hash to xml.
    # @param [Hash] hash hash
    # @param [String] root_name root element name
    # @param [String] attr_name attribute name
    # @return [XmlParser::Document] parser
    def self.parse_xml_from_hash(hash, root_name, attr_name)

      doc = REXML::Document.new("<#{root_name}/>")

      # create under root element.
      hash.each { |key, value|
        elm = parse_element_from_hash(key, value, attr_name)
        doc.root.add(elm)
      }

      XmlParser::Document.new(doc)
    end

    # parse element from yml hash.
    # @param [String] key key, set element name.
    # @param [String / Hash] value if value is String, set value attribute. but value is Hash, call this method.
    # @param [String] attr_name attribute name
    # @return [REXML::Element] element
    def self.parse_element_from_hash(key, value, attr_name)

      elm = REXML::Element.new(key)

      # if value is String
      if value.is_a?(String)
        # set attribute. default attribute name = value.
        elm.add_attribute(attr_name, value)
      # if value is Hash
      elsif value.is_a?(Hash)
        # create child element.
        value.each { |c_key, c_value|
          c_elm = parse_element_from_hash(c_key, c_value, attr_name)
          elm.add(c_elm)
        }
      end

      elm
    end
  end
end
