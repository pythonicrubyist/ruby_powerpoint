require 'zip/zipfilesystem'
require 'nokogiri'

module RubyPowerpoint
  class RubyPowerpoint::Slide

    attr_reader :presentation,
                :path,
                :ndex

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
  end
end