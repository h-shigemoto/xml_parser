require "rexml/document"
require "pp"

# XML Parser module
module XmlParser

  # Document Class
  class Document

    # constructor.
    # @param [String] xml_str xml string.
    def initialize(xml_str)
      @doc = REXML::Document.new(xml_str)
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

    # if xpath math, do each process.
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

    # initialize from File.
    # @param [String] filepath read fileptah. absolute.
    # @return [XmlParser::Document] parser.
    def self.from_file(filepath)

      # read file contents.
      xml_str = File.read(filepath)
      XmlParser::Document.new(xml_str)
    end
  end
end