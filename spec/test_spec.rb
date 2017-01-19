require 'ruby_powerpoint'

describe 'RubyPowerpoint trying to parsing an invalid file.' do
  it 'not open an XLS file successfully.' do
    expect { RubyPowerpoint::Presentation.new 'specs/fixtures/invalid.xls' }.to raise_error 'Not a valid file format.'
  end
end

describe 'RubyPowerpoint parsing a sample PPTX file' do
  before(:all) do
    @deck = RubyPowerpoint::Presentation.new 'spec/fixtures/sample.pptx'
  end

  after(:all) do
    @deck.close
  end

  it 'parse a PPTX file successfully.' do
    expect(@deck).to_not be_nil
    expect(@deck.slides).to_not eql []
    expect(@deck.slides.first.content).to eql ["Some test ", "Powerpoint"]
    expect(@deck.slides.first.content).to eql  ["Some test ", "Powerpoint"]
    image_byte_stream_1 = @deck.slides.first.images.first.read
    File.open('temp_1.jpg', 'w'){|f| f.puts image_byte_stream_1}

    expect(@deck.slides.first.images.first).to_not eql nil #"ppt/media/image1.jpeg"
    expect(@deck.slides.last.title).to eql "Some title here"
    expect(@deck.slides.last.content).to eql ["Some title here", "Some txt here", "Some ", "more text here."]
    image_byte_stream_2 = @deck.slides.last.images.first.read
    File.open('temp_2.jpg', 'w'){|f| f.puts image_byte_stream_2}
  end

  it "it parses Slide Notes of a PPTX  slides" do
    notes_content = @deck.slides[0].notes_content
    expect(notes_content).to eql ["Testing", " Multiline Notes.", "To be extracted here.", "Multiline notes extracted.", "1"]
  end

end

describe 'open rime.pptx file' do
  before(:all) do
    @deck = RubyPowerpoint::Presentation.new 'spec/fixtures/rime.pptx'
  end

  after(:all) do
    @deck.close
  end

  it 'opened rime.pptx successfully' do
    expect(@deck).to_not be_nil
    expect(@deck.slides).to_not eql []
  end

  it 'should have the right number of slides' do
    expect(@deck.slides.length).to eql 12
  end

  it 'the old content method should work the same way' do
    expect(@deck.slides[0].content).to eql ["The Rime of the Ancient Mariner", "(text of 1834)", "http://rpo.library.utoronto.ca/poems/rime-ancient-mariner-text-1834"]
  end

  context 'the titles should be right' do
    it 'should be able to get a main slide (usually centered)' do
      expect(@deck.slides[0].title).to eql "The Rime of the Ancient Mariner"
    end
    it 'should be able to get regular slide titles' do
      expect(@deck.slides[1].title).to eql "Argument"
      expect(@deck.slides[2].title).to eql "PART I"
      expect(@deck.slides[3].title).to eql "PART II"
      expect(@deck.slides[4].title).to eql "Part III"
      expect(@deck.slides[8].title).to eql "There's more"
    end
    it 'should return nil if the slide has no title' do
      expect(@deck.slides[5].title).to be_nil
      expect(@deck.slides[6].title).to be_nil
    end

    it 'should only get one title even if there are two things that visually look like titles' do
      expect(@deck.slides[7].title).to eql "What if we have two"
    end

    context 'when slide contains paragraph' do
      before(:all) do
        @slide = @deck.slides[1]
      end

      it 'should return the list of paragraphs' do
        expect(@slide.paragraphs.count).to eql 2
      end

      it 'should return the content of the paragraph' do
        expect(@slide.paragraphs[0].content).to eq ['Argument']
      end
    end
  end
end
