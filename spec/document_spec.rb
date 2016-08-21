require 'spec_helper'

describe XmlParser::Document do

  let(:xml_string) {
xml_string =<<XML
<?xml version="1.0" encoding="UTF-8" ?>
<sample>
  <elt name="sample1" age="15" />
  <elt name="sample2" age="20" />
  <elt name="sample3" age="25">SampleText3</elt>
</sample>
XML
  }
  let(:xml_filepath) { "C:/GitHub/sample.xml" }

  it 'initialize test' do

    parser = XmlParser::Document.new(xml_string)
    expect(parser.is_a?(XmlParser::Document)).to be_truthy
  end

  it 'initialize from file test' do

    File.write(xml_filepath, xml_string)

    parser = XmlParser::Document.from_file(xml_filepath)
    expect(parser.is_a?(XmlParser::Document)).to be_truthy

    File.delete(xml_filepath)
  end

  it 'xpath map test' do
    parser = XmlParser::Document.new(xml_string)
    value = parser.xpath_map("/sample/elt/text()")

    expect(value.first).to eq "SampleText3"
  end

  it 'xpath map with block test' do

    parser = XmlParser::Document.new(xml_string)
    value = parser.xpath_map("/sample/elt/@name") { |elm|
      elm.value + " map"
    }.join(',')

    expect(value).to eq "sample1 map,sample2 map,sample3 map"
  end

  it 'xpath each with block test' do

    parser = XmlParser::Document.new(xml_string)
    value = nil
    parser.xpath_each("/sample/elt/@name") { |elm|
      if elm.value == "sample3"
        value = elm.value
      end
    }

    expect(value).to eq "sample3"
  end
end