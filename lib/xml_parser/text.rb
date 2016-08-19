require "rexml/text"

# XML Parser module
module XmlParser

  # Text Class
  class Text

    # normalize string.
    # @param [String] str target string.
    # @param [REXML:DocType] doctype document type.
    # @param [Array] filter entity filter.
    # @return [String] normalize string.
    def self.normalize(str, doctype=nil, filter=nil)

      # normalize.
      REXML::Text.normalize(str, doctype, filter)
    end

    # normalize string array.
    # @param [Array] strs target string array.
    # @param [REXML:DocType] doctype document type.
    # @param [Array] filter entity filter.
    # @return [Array] normalize string array.
    def self.multi_normalize(strs, doctype=nil, filter=nil)

      # multi string normalize.
      strs.map { |str|
        normalize(str, doctype, filter)
      }
    end

    # unnormalize string.
    # @param [String] str target string.
    # @param [REXML:DocType] doctype document type.
    # @param [Array] filter entity filter.
    # @return [String] unnormalize string.
    def self.unnormalize(str, doctype=nil, filter=nil)

      REXML::Text.unnormalize(str, doctype, filter)
    end

    # unnormalize string array.
    # @param [Array] strs target string array.
    # @param [REXML:DocType] doctype document type.
    # @param [Array] filter entity filter.
    # @return [Array] unnormalize string array.
    def self.multi_unnormalize(strs, doctype=nil, filter=nil)

      strs.map { |str|
        unnormalize(str, doctype, filter)
      }
    end
  end
end
