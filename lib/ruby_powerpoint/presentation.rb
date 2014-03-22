require 'zip/zipfilesystem'
require 'nokogiri'

module RubyPowerpoint

  class RubyPowerpoint::Presentation

    attr_reader :files

    def initialize path
      raise 'Not a valid file format.' unless (['.pptx'].include? File.extname(path).downcase)
      @files = Zip::ZipFile.open path
    end

    def slides
      slides = Array.new
      @files.each do |f|
        if f.name.include? 'ppt/slides/slide'
          slides.push RubyPowerpoint::Slide.new(self, f.name)
        end
      end
      slides.sort{|a,b| a.slide_num <=> b.slide_num}
    end

    def close
      @files.close
    end
  end
end
