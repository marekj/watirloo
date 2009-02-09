require File.dirname(__FILE__) + '/test_helper'

describe "SelectList options as visible items and values as hidden to the user attributes" do
  
  class SelectListTest3 < Watirloo::Page
    face(:pets => [:select_list, :name, 'animals'],
      :gender => [:select_list, :name, 'sex_cd'],
      :toys => [:select_list, :name, 'bubel'])
  end
  
  before do
    @page = SelectListTest3.new
    @page.b.goto testfile('select_lists.html')
  end
  
  it 'values of options by facename method' do
    @page.gender.values.should == ['', 'm', 'f']
    @page.pets.values.should == ['o1', 'o2', 'o3', 'o4', 'o5']
  end
  
  it 'options with no value attribute' do
    # in case of IE it will return all blanks
    if @page.b.kind_of?(Watir::IE)
      @page.toys.values.should == ["", "", "", "", ""]
    elsif @page.b.kind_of?(FireWatir::Firefox)
      @page.toys.values.should == ["", "foobel", "barbel", "bazbel", "chuchu"]
      # for Firfox it returns actual items 
    end
  end
  
  it 'items method returns visible contents as array of text items' do
    @page.toys.items.should == ["", "foobel", "barbel", "bazbel", "chuchu"]
  end
  
  it 'items returns visible text items as array' do
    @page.pets.items.should == ['cat', 'dog', 'zook', 'zebra', 'wumpa']
    @page.gender.items.should == ["", "M", "F"]
  end
  
  
end