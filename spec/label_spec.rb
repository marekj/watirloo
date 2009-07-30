require File.dirname(__FILE__) + '/spec_helper'


describe 'text field wrapped in label tag without for attribute defined' do
  
  include Watirloo::Page
  face(:first) { text_field(:name, 'fn') }
  face(:last) { text_field(:name, 'ln') }
  
  before do
    browser.goto testfile('labels.html')
  end
  
  it 'parent of text_field should be Watir Element' do
    if browser.kind_of?(FireWatir::Firefox)
      first.parent.should be_kind_of(String)
      last.parent.should be_kind_of?(String)
      flunk('FIXME Firefox returns String for parent and not Element')
      
    elsif browser.kind_of?(Watir::IE)
      first.parent.should be_kind_of(Watir::Element)
      last.parent.should be_kind_of(Watir::Element)
    end
    
  end
  
  it 'parent tagName should be a LABEL' do
    if browser.kind_of?(Watir::IE)
      first.parent.document.tagName.should == "LABEL"
      last.parent.document.tagName.should == "LABEL"

    elsif browser.kind_of?(FireWatir::Firefox)
      flunk('FIXME Firefox returns String for parent and not Element')
    end
  end
  
  it 'parent text returns text of label' do
    if browser.kind_of?(Watir::IE)
      first.parent.text.should == 'First Name'
      last.parent.text.should == 'Last Name'

    elsif browser.kind_of?(FireWatir::Firefox)
      flunk('FIXME Firefox returns String for parent and not Element.')
    end
  end
end



describe 'label for text field not wrapped' do

  # reopen the class and add more interfaces
  include Watirloo::Page
  face(:first_label) { label(:for, 'first_nm') }
  face(:last_label) { label(:for, 'last_nm') }
  
  before do
    browser.goto testfile('labels.html')
  end
  
  it 'text value of label' do
    first_label.text.should == 'FirstName For'
    last_label.text.should == 'LastName For'
  end
end
