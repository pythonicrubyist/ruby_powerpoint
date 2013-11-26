module RubyPowerpoint

  class RubyPowerpoint::Presentation

    attr_reader :files

    def initialize path
      raise 'Not a valid file format.' unless (['.pptx'].include? File.extname(path).downcase)
      @files = Zip::ZipFile.open path
    end

    def slides
      slides = Array.new
      @files.each_with_index do |doc, i|
        if doc.name.include? 'ppt/slides/slide'
          slides.push RubyPowerpoint::Slide.new(self, doc.name, i)
        end
      end
      slides
    end

    def close
      @files.close
    end
  end
end
