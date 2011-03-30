require File.dirname(__FILE__) + '/spec_helper'

describe "SelectList options as visible items and values as hidden to the user attributes" do
  
  include Watirloo::Page

  field(:pets) { select_list(:name, 'animals') }
  field(:gender) { select_list(:name, 'sex_cd') }
  field(:toys) { select_list(:name, 'bubel') }
  
  before :each do
    browser.goto testfile('select_lists.html')
  end
  
  it 'values of options by facename method' do
    gender.values.should == ['', 'm', 'f']
    pets.values.should == ['o1', 'o2', 'o3', 'o4', 'o5']
  end
  
  it 'options with no value attribute' do
    # in case of IE it will return all blanks
    if browser.kind_of?(Watir::IE)
      toys.values.should == ["", "", "", "", ""]
    elsif browser.kind_of?(FireWatir::Firefox)
      toys.values.should == ["", "foobel", "barbel", "bazbel", "chuchu"]
      # for Firfox it returns actual items
    end
  end
  
  it 'items method returns visible contents as array of text items' do
    toys.items.should == ["", "foobel", "barbel", "bazbel", "chuchu"]
  end
  
  it 'items returns visible text items as array' do
    pets.items.should == ['cat', 'dog', 'zook', 'zebra', 'wumpa']
    gender.items.should == ["", "M", "F"]
  end
  
  
end