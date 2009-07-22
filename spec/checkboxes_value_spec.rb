require File.dirname(__FILE__) + '/spec_helper'

describe 'setting and getting values for individual checkboxes with value attributes in face definitions' do

  # in watir you have to access each checkbox, we now have checkbox_group for this
  # in Watirloo you can access CheckboxGroup as shortcut using
  # :pets => [:checkbox_group, 'pets']
  include Watirloo::Page
  face(:pets_cat) { doc.checkbox(:name, 'pets', 'cat') }
  face(:pets_dog) { doc.checkbox(:name, 'pets', 'dog') }
  face(:pets_zook) { doc.checkbox(:name, 'pets', 'zook') }
  face(:pets_zebra) { doc.checkbox(:name, 'pets', 'zebra') }
  face(:pets_wumpa) { doc.checkbox(:name, 'pets', 'wumpa') }
  
  before do
    browser.goto testfile('checkbox_group1.html')
  end
  
  it 'semantic name accesses individual CheckBox' do
    if browser.kind_of?(FireWatir::Firefox)
      pets_cat.should be_kind_of(FireWatir::CheckBox)
      
    elsif browser.kind_of?(Watir::IE)
      pets_cat.should be_kind_of(Watir::CheckBox)
    end
  end
  
  it 'set individual checkbox does not set other checkboxes sharing the same name' do
    pets_dog.should_not be_checked
    pets_dog.set true
    pets_dog.should be_checked
    pets_cat.should_not be_checked
  end
  
end
