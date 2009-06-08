require File.dirname(__FILE__) + '/test_helper'
describe 'label wrapping text field' do
  
  class Labels < Watirloo::Page
    face :first => [:text_field, :name, 'fn']
    face :last => [:text_field, :name, 'ln']
  end
  
  before do
    @page = Labels.new
    @page.browser.goto testfile('labels.html')
  end
  
  it 'accessed by parent should be Watir Element' do
    if @page.b.kind_of?(FireWatir::Firefox)
      @page.first.parent.should be_kind_of(String)
      @page.last.parent.should be_kind_of?(String)
      flunk('FIXME Firefox returns String for parent and not Element')
      
    elsif @page.b.kind_of?(Watir::IE)
      @page.first.parent.should be_kind_of(Watir::Element)
      @page.last.parent.should be_kind_of(Watir::Element)
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

  # reopen the class and add more interfaces
  class Labels < Watirloo::Page
    face :first_label => [:label, :for, 'first_nm']
    face :last_label => [:label, :for, 'last_nm']
  end
  
  before do
    @page = Labels.new
    @page.goto testfile('labels.html')
  end
  
  it 'value of label' do
    @page.first_label.text.should == 'FirstName For'
    @page.last_label.text.should == 'LastName For'
  end
end


