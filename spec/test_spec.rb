require 'ruby_powerpoint'

describe 'RubyPowerpoint trying to parsing an invalid file.' do
  it 'not open an XLS file successfully.' do
    lambda { RubyPowerpoint::Presentation.new 'specs/fixtures/invalid.xls' }.should raise_error 'Not a valid file format.'
  end
end

describe 'RubyPowerpoint parsing a sample PPTX file' do
  before(:all) do
    @deck = RubyPowerpoint::Presentation.new 'spec/fixtures/sample.pptx'
  end

  after(:all) do
    @deck.close
  end

  it 'open a PPTX file successfully.' do
    @deck.should_not be_nil
    @deck.slides.should_not eql []
    @deck.slides.first.content.should eql ["Some header here", "Some content here."]
    @deck.slides.last.content.should eql ["WTF?", "What the hell s gong on?", "1234", "asdf", "34", "6"]
  end
end
