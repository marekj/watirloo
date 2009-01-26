require File.dirname(__FILE__) + '/test_helper'

describe 'setting and getting values for individual checkboxes with value attributes in face definitions' do
  
  before do
    @page = Watirloo::Page.new
    @page.browser.goto testfile('checkbox_group1.html')
    
    # instance method page.face adds defintion but only to the current instance of the page
    # in watir you have to access each checkbox. 
    # in Watirloo you can access CheckboxGroup as shortcut using
    # :pets => [:checkbox_group, 'pets']
    @page.face(
      :pets_cat => [:checkbox, :name, 'pets', 'cat'],
      :pets_dog => [:checkbox, :name, 'pets', 'dog'],
      :pets_zook => [:checkbox, :name, 'pets', 'zook'],
      :pets_zebra => [:checkbox, :name, 'pets', 'zebra'],
      :pets_wumpa => [:checkbox, :name, 'pets', 'wumpa'])
  end
  
  it 'semantic name accesses individual CheckBox' do
    if @page.b.kind_of?(FireWatir::Firefox)
      @page.pets_cat.kind_of?(FireWatir::CheckBox).should == true
      
    elsif @page.b.kind_of?(Watir::IE)
      @page.pets_cat.kind_of?(Watir::CheckBox).should == true
    end
  end
  
  it 'set individual checkbox does not set other checkboxes sharing the same name' do
    @page.pets_dog.checked?.should == false
    @page.pets_dog.set
    @page.pets_dog.checked?.should == true
    @page.pets_cat.checked?.should == false
  end
  
  it 'by default all are false. set each unchecked checkbox should have checked? true' do
    @page.interfaces.keys.each do |key|
      @page.get_face(key).checked?.should == false
    end

    @page.interfaces.keys.each do |key|
      @page.get_face(key).set
    end
    
    @page.interfaces.keys.each do |key|
      @page.get_face(key).checked?.should.be true
    end
  end
end
