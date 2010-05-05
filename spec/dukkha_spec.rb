require 'dukkha'
require 'net/http'

describe "the dukkha application" do

  before(:each) do
    @dukkha = Dukkha.new
  end
  
  it "should expect a config.xml file" do
    file = "invalid.xml"
    lambda { @dukkha.load_config(file) }.should raise_error(RuntimeError, "Invalid config #{file}")
  end
  
  it "should be able to parse a valid config.xml file" do
    lambda { @dukkha.load_config }.should_not raise_error
  end
  
  describe "with a loaded config" do
  
    before(:each) do 
      @dukkha = Dukkha.new(true)
    end
    
    it "should create an array of width/height based on the <cells> property of the config.xml file" do
      @dukkha.cells.length.should == 6
      @dukkha.cells.each {|cell| cell.length.should == 10}
    end
  
    it "should create a cell object for each <cell> entry in the config.xml file and a nil object otherwise" do
      @dukkha.cells.each do |x|
        x.each do |y|
          # tbd - would prefer to have and/or expression for NilClass here - pm
          y.should be_a_kind_of(Cell) if y
        end
      end   
    end
  
  it "should support an HTTP GET to /" do
    mock_dukkha = mock(@dukkha)
    mock_dukkha.should_receive(:get).with("/")
    mock_dukkha.get("/")
  end
  
  describe "a cell entry" do
    it "should have coords, image, text, background, url, color" do
      cell = @dukkha.cells.first.first
      
      # if we grab this list from the class, does it defeat the purpose of the test ?
      [:url, :image, :text, :background, :color].each do |attr|
        cell.should respond_to attr
        cell.send(attr).should_not be_nil
      end
    end
  end
end  
end
