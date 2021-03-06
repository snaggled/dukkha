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

class Dukkha
  attr :cells
  
  def initialize(load = false); @cells = load_config if load; end
    
  # cells is a multi-dimensional array [[1,2,3,4,5,6], [1,2,3,4,5,6] ...]
  def load_config(xml_config="#{File.dirname(__FILE__)}/config.xml")
    raise(RuntimeError, "Invalid config #{xml_config}") if !File.exists?(xml_config)
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

  # one url, load the config each time
  get '/' do
    @cells = load_config
    erb :index
  end
end # dukkha

