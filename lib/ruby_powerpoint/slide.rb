require 'zip/filesystem'
require 'nokogiri'

module RubyPowerpoint
  class RubyPowerpoint::Slide

    attr_reader :presentation,
                :slide_number,
                :slide_number,
                :slide_file_name

    def initialize presentation, slide_xml_path
      @presentation = presentation
      @slide_xml_path = slide_xml_path
      @slide_number = extract_slide_number_from_path slide_xml_path
      @slide_file_name = extract_slide_file_name_from_path slide_xml_path
      parse_slide
      parse_relation
    end

    def parse_slide 
      slide_doc = @presentation.files.file.open @slide_xml_path
      @slide_xml = Nokogiri::XML::Document.parse slide_doc
    end

    def parse_relation
      @relation_xml_path = "ppt/slides/_rels/#{@slide_file_name}.rels"
      if @presentation.files.file.exist? @relation_xml_path
        relation_doc = @presentation.files.file.open @relation_xml_path
        @relation_xml = Nokogiri::XML::Document.parse relation_doc
      end
    end

    def content
      content_elements @slide_xml
    end
    
    def title
      title_elements = title_elements(@slide_xml)
      title_elements.join(" ") if title_elements.length > 0
    end

    def images
      image_elements(@relation_xml)
        .map.each do |node|
          @presentation.files.file.open(
            node['Target'].gsub('..', 'ppt'))
        end
    end
   
    def slide_num
      @slide_xml_path.match(/slide([0-9]*)\.xml$/)[1].to_i
    end
 
    private

    def extract_slide_number_from_path path
      path.gsub('ppt/slides/slide', '').gsub('.xml', '').to_i
    end

    def extract_slide_file_name_from_path path
      path.gsub('ppt/slides/', '')
    end

    def title_elements(xml)
      shape_elements(xml).select{ |shape| element_is_title(shape) }
    end
    
    def content_elements(xml)
      xml.xpath('//a:t').collect{ |node| node.text }
    end

    def image_elements(xml)
      xml.css('Relationship').select{ |node| element_is_image(node) }
    end    

    def shape_elements(xml)
      xml.xpath('//p:sp')
    end    
  
    def element_is_title(shape)
      shape.xpath('.//p:nvSpPr/p:nvPr/p:ph').select{ |prop| prop['type'] == 'title' || prop['type'] == 'ctrTitle' }.length > 0
    end

    def element_is_image(node)
      node['Type'].include? 'image' 
    end
  end
end
