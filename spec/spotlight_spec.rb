require 'spec_helper'

describe "Initialization" do
  
  before(:each) do
    FakeWeb.register_uri(:get, 
      "http://api.hostip.info/?ip=199.246.67.211",
      :string => File.read(File.join(File.dirname(__FILE__), 
        'fixtures', 
        '199_246_67_211.xml')
      )
    )
  end
  
  it "should require an ip address" do
    lambda { Spotlight.new }.should raise_error
      
    Spotlight.new("199.246.67.211").ip.should == "199.246.67.211"
  end
  
  it "should require a proper ip address" do
    lambda { Spotlight.new(199) }.should raise_error
    lambda { Spotlight.new(199.246) }.should raise_error
    lambda { Spotlight.new({:test => "test"}) }.should raise_error
    lambda { Spotlight.new(["test"]) }.should raise_error
    lambda { Spotlight.new("199") }.should raise_error
    lambda { Spotlight.new("199.246") }.should raise_error
    lambda { Spotlight.new("199.246.67") }.should raise_error
    lambda { Spotlight.new("aaa.246.67.211") }.should raise_error
    lambda { Spotlight.new("199.aaa.67.211") }.should raise_error
    lambda { Spotlight.new("199.246.aaa.211") }.should raise_error
    lambda { Spotlight.new("199.246.67.aaa") }.should raise_error
    lambda { Spotlight.new("") }.should raise_error
    lambda { Spotlight.new(" ") }.should raise_error
    lambda { Spotlight.new("aaa") }.should raise_error
    
    # sanity check
    lambda { Spotlight.new("199.246.67.211") }.should_not raise_error
  end
    
end

describe "Spotlight" do
  
  it "should create an ip based key" do
    Spotlight.key("199.246.67.211").should == "spotlight-199.246.67.211"
  end
    
  it "should create an ip based key with defined prefix" do
    Spotlight.key("199.246.67.211", "alternate").should == "alternate-199.246.67.211"
  end

end

describe "Data" do
  
  it "should require data" do
    lambda { Spotlight::Data.new }.should raise_error
      
    data = {'foo' => {'data' => 'bar'}}
    Spotlight::Data.new(data).data.should == data
  end
  
end

describe "Location" do
  
  it "should require data" do
    lambda { Spotlight::Location.new }.should raise_error
      
    data = {'foo' => {'data' => 'bar'}}
    Spotlight::Location.new(data).data.should == data
  end
  
  it "should return nil when the data does not exist" do
    data = {}
    location = Spotlight::Location.new(data)
    location.should_not be_nil
    
    location.name.should be_nil
    location.coordinates.should be_nil
    location.longitude.should be_nil
    location.latitude.should be_nil
  end
  
  # @data['Hostip']['gml:name']
  it "should respond to name" do
    data = {'Hostip' => {'gml:name' => "test_name"}}
    location = Spotlight::Location.new(data)
    location.should_not be_nil
    
    location.name.should == "test_name"
  end
  
  # @data['Hostip']['ipLocation']['gml:PointProperty']['gml:Point']['gml:coordinates']
  it "should respond to coordinates" do
    data = {'Hostip' => {'ipLocation' => {'gml:PointProperty' => {'gml:Point' => {'gml:coordinates' => "-79.3833,43.65"}}}}}
    location = Spotlight::Location.new(data)
    location.should_not be_nil
    
    location.coordinates.should == "-79.3833,43.65"
  end
  
  # @data['Hostip']['ipLocation']['gml:PointProperty']['gml:Point']['gml:coordinates']
  it "should respond to longitude" do
    data = {'Hostip' => {'ipLocation' => {'gml:PointProperty' => {'gml:Point' => {'gml:coordinates' => "-79.3833,43.65"}}}}}
    location = Spotlight::Location.new(data)
    location.should_not be_nil
    
    location.longitude.should == -79.3833
  end

  # @data['Hostip']['ipLocation']['gml:PointProperty']['gml:Point']['gml:coordinates']
  it "should respond to latitude" do
    data = {'Hostip' => {'ipLocation' => {'gml:PointProperty' => {'gml:Point' => {'gml:coordinates' => "-79.3833,43.65"}}}}}
    location = Spotlight::Location.new(data)
    location.should_not be_nil
    
    location.latitude.should == 43.65
  end
  
end
  
describe "Country" do

  it "should require data" do
    lambda { Spotlight::Country.new }.should raise_error

    data = {'foo' => {'data' => 'bar'}}
    Spotlight::Country.new(data).data.should == data
  end

  it "should return nil when the data does not exist" do
    data = {}
    country = Spotlight::Country.new(data)
    country.should_not be_nil

    country.name.should be_nil
    country.code.should be_nil
  end

  # @data['Hostip']['countryName']
  it "should respond to name" do
    data = {'Hostip' => {'countryName' => "test_name"}}
    country = Spotlight::Country.new(data)
    country.should_not be_nil

    country.name.should == "test_name"
  end

  # @data['Hostip']['countryAbbrev']
  it "should respond to coordinates" do
    data = {'Hostip' => {'countryAbbrev' => "CA"}}
    country = Spotlight::Country.new(data)
    country.should_not be_nil

    country.code.should == "CA"
  end

end

describe "Fetching" do
  
  before(:each) do
    FakeWeb.register_uri(:get, 
      "http://api.hostip.info/?ip=199.246.67.211",
      :string => File.read(File.join(File.dirname(__FILE__), 
        'fixtures', 
        '199_246_67_211.xml')
      )
    )
    @spotlight = Spotlight.new("199.246.67.211")
  end
  
  it "should have location information" do
    @spotlight.location.should_not be_nil
    location = @spotlight.location
    location.name.should == 'TORONTO, ON'
    location.coordinates.should == '-79.3833,43.65'
    location.longitude.should == -79.3833
    location.latitude.should == 43.65
  end
  
  it "should have country information" do
    @spotlight.country.should_not be_nil
    country = @spotlight.country
    country.name.should == 'CANADA'
    country.code.should == 'CA'
  end
  
end
