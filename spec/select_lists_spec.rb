require 'spec_helper'

# testing single select and multiselect controls
describe "SelectList selections" do

  include Watirloo::Page

  field(:pets) {select_list(:name, 'animals')} #multiselect
  field(:gender) {select_list(:name, 'sex_cd')} #single select

  before do
    browser.goto testfile('select_lists.html')
  end

  it 'selected returns preselected item in single select' do
    gender.selected.should == '' # in single select "" is preselected
    gender.selected_item.should == '' # in single select "" is preselected
    gender.selected_items.should == ['']
  end
  
  it 'selected returns preselected value in single select' do
    gender.selected_value.should == '' # in single select "" is preselected
    gender.selected_values.should == ['']
  end

  it 'selected returns nil for none selected items in multi select' do
    pets.selected.should == nil # in multiselect noting is selected
    pets.selected_item.should == nil
    pets.selected_items.should == [] # as array
  end

  it 'selected returns nil for none selected values in multi select' do
    pets.selected_value.should == nil
    pets.selected_values.should == [] # as array
  end
  
  it 'set item text and find selected item and text for multiselect' do
    pets.set 'dog'
    pets.selected.should == 'dog' #multi select one item selected
    pets.selected_item.should == 'dog' #multi select one item selected
    pets.selected_items.should == ['dog']
  end
  
  it 'set value and find selected item and value for multiselect' do
    pets.set_value 'o2'
    pets.selected.should == 'dog' #multi select one item selected
    pets.selected_value.should == 'o2' #multi select one item selected
    pets.selected_values.should == ['o2']
  end

  it 'set and query option by text for single select' do
    gender.set 'F'
    gender.selected.should == 'F' # single select one item
    gender.selected_item.should == 'F' # single select one item
    gender.selected_items.should == ['F'] # single select one item
  end

  it 'set and query option by value for single select' do
    gender.set_value 'f'
    gender.selected.should == 'F'
    gender.selected_value.should == 'f' # single select one item
    gender.selected_values.should == ['f'] # single select one item
  end

  it 'set by text multple items for multiselect selects each item' do
    pets.set ['cat', 'dog']
    pets.selected.should == ['cat','dog']
    pets.selected_item.should == ['cat','dog'] # bypass filter when more than one item
    pets.selected_items.should == ['cat','dog']
  end

  it 'set by value multple items for multiselect selects each item' do
    pets.set_value ['o1', 'o2']
    pets.selected.should == ['cat','dog']
    pets.selected_value.should == ['o1','o2'] # bypass filter when more than one item
    pets.selected_value.should == ['o1','o2']
  end

  # this is not practical for single select but can be done for testing
  # conditions arising from switching items in a batch approach
  it 'set items array for single select selects each in turn. selected is the last item in array' do
    gender.set ['M', 'F', '','F']
    gender.selected.should == 'F'
  end
  
  it 'set item after multiple items were set returns all values selected for multiselect' do
    pets.set ['cat','zook']
    pets.set 'zebra'
    pets.selected.should == ['cat', 'zook', 'zebra']
    pets.selected_values.should == ['o1', 'o3', 'o4']
  end
  
  it 'set using position for multiselect' do
    pets.set 3
    pets.selected.should == 'zook'
    pets.set_value 2 # translate to second text item
    pets.selected.should == ['dog', 'zook']
    pets.set [1,4,5]
    pets.selected.should == ['cat','dog','zook', 'zebra','wumpa']
  end
  
  it 'set using position and item for multiselect' do
    pets.set [1,'zebra', 'zook', 2, 4] #select already selected
    pets.selected.should == ['cat','dog','zook','zebra']
  end
  
  it 'set using position for single select' do
    gender.set 2
    gender.selected.should == 'M'
    gender.selected_value.should == 'm'
  end
  
  it 'clear removes selected attribute for all selected items in multiselect' do
    pets.selected.should == nil
    pets.set ['zook', 'cat']
    pets.selected.should == ['cat','zook']
    pets.clear
    pets.selected.should == nil
  end

  it 'clear removes selected attribute for item in single select list' do
    gender.selected.should == ''
    gender.set 'F'
    gender.selected.should == 'F'

    # This fails on IE in single select list.
    # The test passes in Firefox
    # option item select = false does not set false like it does in multiselect
    gender.clear
    gender.selected.should_not == 'F'
  end
  
  it 'set_value selects value atribute text' do
    gender.set_value 'm'
    gender.selected.should == 'M'
    gender.selected_value.should == 'm' #when you know there is only one item expected
    gender.selected_values.should == ['m'] # array of items
  end
  
  it 'set_value for multiselect returns selected and selected_values' do
    pets.set_value 'o2'
    pets.set_value 'o4'
    pets.selected.should == ['dog', 'zebra']
    pets.selected_value.should == ['o2', 'o4'] # if array then bypass filter
    pets.selected_values.should == ['o2', 'o4'] # plural
  end
end
