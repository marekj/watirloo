require File.dirname(__FILE__) + '/test_helper'

describe 'checkbox_group access for browser' do
  before :each do
    page = Watirloo::Page.new
    @browser = page.browser
    @browser.goto testfile('checkbox_group1.html')
  end
  
  it 'browser responds to checkbox_group' do
    @browser.respond_to?(:checkbox_group).should == true
  end
  
  it 'returns group object and its values from the page' do
    cbg = @browser.checkbox_group('pets')
    cbg.size.should == 5
    cbg.values.should == %w[cat dog zook zebra wumpa]
  end
end

describe 'CheckboxGroup class access with page interface' do 

  class CheckboxGroupPage < Watirloo::Page
    # semantic wrapper for the radio group object
    face :pets => [:checkbox_group, 'pets']
  end
  
  before do
    @page = CheckboxGroupPage.new
    @page.b.goto testfile('checkbox_group1.html')
  end

  # let's check explicitly for test purpose what Class is we are dealing with
  # if IE then Watir::CheckboxGroup
  # if FF then FireWatir::CheckboxGroup
  it 'checkbox_group container method returns CheckboxGroup class' do
    if @page.b.kind_of?(FireWatir::Firefox)
      @page.pets.kind_of?(FireWatir::CheckboxGroup).should == true
      
    elsif  @page.b.kind_of?(Watir::IE)
      @page.pets.kind_of?(Watir::CheckboxGroup).should == true
    end
  end
  
  it 'size retuns checkboxes as items count in a group' do
    @page.pets.size.should == 5
  end
  
  it 'values returns array of value attributes for each checkbox in a group' do
    @page.pets.values.should == ["cat", "dog", "zook", "zebra", "wumpa"]
  end
  
  it 'selected_values returns array of value attributes of each selected checkbox' do
    @page.pets.selected.should == nil
    @page.pets.selected_value.should == nil
    @page.pets.selected_values.should == []
  end
  
  it 'set String checks the checkbox in a group where value is String' do
    @page.pets.set 'dog'
    @page.pets.selected.should == 'dog'
    @page.pets.selected_value.should == 'dog'
    @page.pets.selected_values.should == ['dog']
  end
  
  it 'set String array checks each checkbox by hidden value String' do
    @page.pets.set ['dog', 'zebra', 'cat'] # not in order
    @page.pets.selected.should == ['cat', 'dog', 'zebra']
    @page.pets.selected_value.should == ['cat', 'dog', 'zebra'] # bypass filter
    @page.pets.selected_values.should == ['cat', 'dog', 'zebra']
  end
  
  it 'set Fixnum checks checkbox by position in a group. Position is 1 based' do
    @page.pets.set 3
    @page.pets.selected_values.should == ['zook']
  end
  
  it 'set array of Fixnums checks each checkbox by position' do
    @page.pets.set [4,1,2] # not in order
    @page.pets.selected_values.should == ["cat", "dog", "zebra"]
  end
  
end