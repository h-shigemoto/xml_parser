require 'spec_helper'

describe XmlParser::Text do

  let(:xml_unnormal_string) { "a > b; < c" }
  let(:xml_normal_string) { "a &gt; b; &lt; c" }
  let(:xml_unnormal_filter_string) { "a > b; &lt; c" }

  it 'normalize test' do

    str = XmlParser::Text.normalize(xml_unnormal_string)
    expect(str).to eq xml_normal_string
  end

  it 'unnormalize test' do

    str = XmlParser::Text.unnormalize(xml_normal_string)
    expect(str).to eq xml_unnormal_string
  end

  it 'multi normalize test' do

    base_array = [xml_unnormal_string, xml_unnormal_string, xml_unnormal_string]
    n_array = XmlParser::Text.multi_normalize(base_array)
    n_array.each { |str|
      expect(str).to eq xml_normal_string
    }
  end

  it 'multi normalize with block test' do

    base_array = [xml_unnormal_string, xml_unnormal_string, xml_unnormal_string]
    n_array = XmlParser::Text.multi_normalize(base_array) { |str|
      str + "a"
    }
    n_array.each { |str|
      expect(str).to eq xml_normal_string + "a"
    }
  end

  it 'multi unnormalize test' do

    base_array = [xml_normal_string, xml_normal_string, xml_normal_string]
    n_array = XmlParser::Text.multi_unnormalize(base_array, nil, ["lt"])
    n_array.each { |str|
      expect(str).to eq xml_unnormal_filter_string
    }
  end

  it 'multi unnormalize with block test' do

    base_array = [xml_normal_string, xml_normal_string, xml_normal_string]
    n_array = XmlParser::Text.multi_unnormalize(base_array, nil, ["lt"]) { |str|
      str + "a"
    }
    n_array.each { |str|
      expect(str).to eq xml_unnormal_filter_string + "a"
    }
  end
end
