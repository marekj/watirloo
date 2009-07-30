require File.dirname(__FILE__) + '/spec_helper'

describe "add faces text fields page objects" do
  
  include Watirloo::Page

  face :last do
    text_field(:name, 'last_nm')
  end

  face :first do
    text_field(:name, 'first_nm')
  end
    
  before do
    browser.goto testfile('person.html')
  end
  
  it 'face returns a watir element text_field' do
    if browser.kind_of? FireWatir::Firefox
      first.should be_kind_of(FireWatir::TextField)
      last.should be_kind_of(FireWatir::TextField)
    elsif browser.kind_of? Watir::IE
      first.should be_kind_of(Watir::TextField)
      last.should be_kind_of(Watir::TextField)
    end
  end
  
  it 'face name method and value returns current text' do
    first.value.should == 'Joanney'
    last.value.should == 'Begoodnuffski'
  end
  
  it "face name method and set enters value into field" do
    params = {:first => 'Grzegorz',:last => 'Brzeczyszczykiewicz'}
    first.set params[:first]
    last.set params[:last]
    first.value.should == params[:first]
    last.value.should == params[:last]
  end
  
  it 'spray method matches keys as facenames and sets values to fields' do
    params = {:first => 'Grzegorz',:last => 'Brzeczyszczykiewicz'}
    spray params
    first.value.should == params[:first]
    last.value.should == params[:last]
    
  end
  it 'scrape keys updates keys with values and returns datamap' do
    datamap = {:first => 'Hermenegilda', :last => 'Kociubinska'}
    spray datamap
    values = scrape datamap.keys
    values.should == datamap
  end
end
 