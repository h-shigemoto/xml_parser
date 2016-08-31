require 'spec_helper'
require 'yaml'

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
  let(:xml_xpath_string) { "<elt age='15' name='sample1'/><elt age='20' name='sample2'/><elt age='25' name='sample3'>SampleText3</elt>" }
  let(:xml_filepath) { "C:/GitHub/sample.xml" }
  let(:yml_string) {
yml_string =<<YML
first:
  second: second_value
  name: name_value
  age: age_value &
  third:
    sample: third_value > 1
first2:
  second: second_value2
  name: name_value2
YML
  }
  let(:yml_fileptah) { "C:/GitHub/sample.yml" }
  let(:yml_xml_string) { "<root><first><second value='second_value'/><name value='name_value'/><age value='age_value &amp;'/><third><sample value='third_value &gt; 1'/></third></first><first2><second value='second_value2'/><name value='name_value2'/></first2></root>" }

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

  it 'xpath to string test' do

    parser = XmlParser::Document.new(xml_string)
    match_str = parser.xpath_to_s("/sample/elt")

    expect(match_str).to eq xml_xpath_string
  end

  it 'xml from yml test' do

    File.write(yml_fileptah, yml_string)

    parser = XmlParser::Document.from_yml(yml_fileptah)
    expect(parser.document.to_s).to eq yml_xml_string

    File.delete(yml_fileptah)
  end

  it 'xml from hash test' do

    hash = YAML.load(yml_string)
    parser = XmlParser::Document.from_hash(hash)
    expect(parser.document.to_s).to eq yml_xml_string
  end

  it 'initialize fail test' do

    expect { parse = XmlParser::Document.new({string: "value"}) }.to raise_error(TypeError)
  end
end
