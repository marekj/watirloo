require File.dirname(__FILE__) + '/test_helper'

describe "add faces text fields page objects" do
  
  before do
    @page = Watirloo::Page.new
    @page.b.goto testfile('person.html')
  end

  it 'interfaces initially is an empty Hash' do
    @page.interfaces.should == {}
  end
  
  it 'instance method face accepts keys as semantic faces and values as definitions to construct Watir Elements' do
    @page.face(
      :last => [:text_field, :name, 'last_nm'],
      :first => [:text_field, :name, 'first_nm'])
    @page.interfaces.size.should == 2
    
    if @page.browser.kind_of? FireWatir::Firefox
      @page.first.kind_of?(FireWatir::TextField).should == true
      @page.last.kind_of?(FireWatir::TextField).should == true
      
    elsif @page.b.kind_of? Watir::IE
      @page.first.kind_of?(Watir::TextField).should == true
      @page.last.kind_of?(Watir::TextField).should == true
    end
  end
end

describe "text fields page objects setting and getting values" do

  before do
    @page = Watirloo::Page.new
    @page.goto testfile('person.html')
    @page.face(
      :last => [:text_field, :name, 'last_nm'],
      :first => [:text_field, :name, 'first_nm']
    )
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
 