require 'rubygems'
require 'sinatra'
require 'hpricot'

class Cell
  @@attrs = [:x, :y, :image, :text, :color, :background, :url, :tooltip]
  @@attrs.each {|a| attr_accessor a }
  
  def initialize(cell)
    @@attrs.each do |a|
      self.send("#{a}=", (cell/a).inner_html)
    end    
    [:x, :y].each {|a| self.send("#{a}=", self.send(a).to_i)}
  end
end

def load_config(xml_config="#{File.dirname(__FILE__)}/config.xml")
  config = File.read(xml_config)
  doc = Hpricot.parse(config)
    
  # cells = multi-dimension array using width & height
  width = (doc/:cells/:width).inner_html.to_i
  height = (doc/:cells/:height).inner_html.to_i
  cells = Array.new(height)
  height.times { |h| cells[h] = Array.new(width) }

  (doc/:cells/:cell).each do |cell_html|
    cell = Cell.new(cell_html)
    cells[cell.y][cell.x] = cell
  end
  cells  
end

get '/' do
  @cells = load_config
  erb :index
end

