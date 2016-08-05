module RubyPowerpoint
  class RubyPowerpoint::Paragraph
    def initialize slide, paragraph_xml
      @slide = slide
      @presentation = slide.presentation
      @paragraph_xml = paragraph_xml
    end

    def content
      content_element @paragraph_xml
    end

    private

    def content_element(xml)
      xml.xpath('.//a:t').collect{ |node| node.text }
    end
  end
end
