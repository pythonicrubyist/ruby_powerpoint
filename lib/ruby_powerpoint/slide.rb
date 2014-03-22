require 'zip/zipfilesystem'
require 'nokogiri'

module RubyPowerpoint
  class RubyPowerpoint::Slide

    attr_reader :presentation,
                :path,
                :index

    def initialize presentation, path, index
      @presentation = presentation
      @path = path
      @index = index
    end

    def content
      content = Array.new
      doc = @presentation.files.file.open @path
      xml = Nokogiri::XML::Document.parse doc
      xml.xpath('//a:t').each do |node|
        content.push node.text
      end
      content
    end
    
    def title
      #extracts just the title from the slide. Useful information on how to find just the title shape using C# is found here: http://msdn.microsoft.com/en-us/library/office/cc850843.aspx but you'll obviously need to dig into the XML structure if you aren't using C#, so see http://msdn.microsoft.com/en-us/library/office/gg278332(v=office.15).aspx
      # should return nil if there is no title
      title_elements = Array.new
      doc = @presentation.files.file.open @path
      xml = Nokogiri::XML::Document.parse doc
      title_elements(xml).join(" ") if title_elements(xml).length > 0
    end
    
    def slide_num
      path.match(/slide([0-9]*)\.xml$/)[1].to_i
    end
    
    protected
    
    def title_elements(xml)
      shape_elements(xml).select{|shape| element_is_title(shape)}
    end
  
    def shape_elements(xml)
      xml.xpath('//p:sp')
    end
  
    def element_is_title(shape)
      shape.xpath('.//p:nvSpPr/p:nvPr/p:ph').select{|prop| prop['type'] == 'title' || prop['type'] == 'ctrTitle'}.length > 0
    end
    
  end
end