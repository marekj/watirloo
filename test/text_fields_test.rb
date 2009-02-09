require File.dirname(__FILE__) + '/test_helper'

describe "add faces text fields page objects" do
  
  class TextFieldFaces < Watirloo::Page
    interface :last => [:text_field, :name, 'last_nm']
    face :first => [:text_field, :name, 'first_nm'] #alias for interface
  end
  
  before do
    @page = TextFieldFaces.new
    @page.browser.goto testfile('person.html')
  end
  
  it 'instance method face accepts keys as semantic faces and values as definitions to construct Watir Elements' do
    @page.interfaces.size.should == 2
    
    if @page.browser.kind_of? FireWatir::Firefox
      @page.first.kind_of?(FireWatir::TextField).should == true
      @page.last.kind_of?(FireWatir::TextField).should == true
      
    elsif @page.b.kind_of? Watir::IE
      @page.first.kind_of?(Watir::TextField).should == true
      @page.last.kind_of?(Watir::TextField).should == true
    end
  end
  
  it 'face name method and value returns current text' do
    @page.first.value.should == 'Joanney'
    @page.last.value.should == 'Begoodnuffski'    
  end
  
  it "face name method and set enters value into field" do
    params = {:first => 'Grzegorz',:last => 'Brzeczyszczykiewicz'}
    @page.first.set params[:first]
    @page.last.set params[:last]
    @page.first.value.should == params[:first]
    @page.last.value.should == params[:last]  
  end
  
  it 'spray method matches keys to semantic values and sets values' do
    params = {:first => 'Grzegorz',:last => 'Brzeczyszczykiewicz'}
    @page.spray params
    @page.first.value.should == params[:first]
    @page.last.value.should == params[:last]  
    
  end
  it 'spray values match semantic keys to faces and set their values' do
    @page.spray :first => 'Hermenegilda', :last => 'Kociubinska'
    @page.first.value.should == 'Hermenegilda'
    @page.last.value.should == 'Kociubinska'
  end
end
 