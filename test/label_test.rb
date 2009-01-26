require File.dirname(__FILE__) + '/test_helper'
describe 'label wrapping text field' do
  
  before do
    @page = Watirloo::Page.new
    @page.browser.goto testfile('labels.html')
    @page.face(
      :first => [:text_field, :name, 'fn'],
      :last => [:text_field, :name, 'ln']
    )
  end
  
  it 'accessed by parent should be Watir Element' do
    if @page.b.kind_of?(FireWatir::Firefox)
      @page.first.parent.kind_of?(String).should == true
      @page.last.parent.kind_of?(String).should == true
      flunk('FIXME Firefox returns String for parent and not Element')
      
    elsif @page.b.kind_of?(Watir::IE)
      @page.first.parent.kind_of?(Watir::Element).should == true
      @page.last.parent.kind_of?(Watir::Element).should == true
    end
    
  end
  
  it 'accessed by parent tagName should be a LABEL' do
    if @page.b.kind_of?(Watir::IE)
      @page.first.parent.document.tagName.should == "LABEL"
      @page.last.parent.document.tagName.should == "LABEL"
    elsif @page.b.kind_of?(FireWatir::Firefox)
      flunk('FIXME Firefox returns String for parent and not Element')
    end
  end
  
  it 'accessed by parent text returns text of label' do
    if @page.b.kind_of?(Watir::IE)
      @page.first.parent.text.should == 'First Name'
      @page.last.parent.text.should == 'Last Name'

    elsif @page.b.kind_of?(FireWatir::Firefox)
      flunk('FIXME Firefox returns String for parent and not Element.')
    end
  end
end

describe 'label for text field' do
  before do
    @page = Watirloo::Page.new
    @page.goto testfile('labels.html')
    @page.face(
      :first => [:text_field, :id, 'first_nm'],
      :last => [:text_field, :id, 'last_nm'],
      :first_label => [:label, :for, 'first_nm'],
      :last_label => [:label, :for, 'last_nm']
    )
  end
  
  it 'value of label' do
    @page.first_label.text.should == 'FirstName For'
    @page.last_label.text.should == 'LastName For'
  end
end


