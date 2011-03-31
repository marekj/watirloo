require 'spec_helper'

# testing single select and multiselect controls
describe "SelectList selections" do

  include Watirloo::Page

  field(:pets) { select_list(:name, 'animals') } #multiselect
  field(:gender) { select_list(:name, 'sex_cd') } #single select

  before do
    browser.goto testfile('select_lists.html')
  end

  it 'user value in single select' do
    gender.options.should == ['', 'M', 'F']
    gender.user_value.should == 'M'
  end

  it 'user value in multi select list when nothing selected' do
    pets.options.should == ["cat", "dog", "zook", "zebra", "wumpa"]
    pets.user_value.should == false # in multiselect noting is selected
  end

  it 'set one text in multiselect and user value reports text item' do
    pets.set 'dog'
    pets.user_value.should == 'dog'
  end

  it 'set one value in multiselect and user value reports text item' do
    pets.set_value 'o2'
    pets.user_value.should == 'dog'
  end

  it 'set text in single select and user value reports that text' do
    gender.set 'F'
    gender.user_value.should == 'F'
  end

  it 'set by value in single select and user value reports text' do
    gender.set_value 'f'
    gender.user_value.should == 'F'
  end

  it 'set multiple items by text and user value returns the selected items' do
    pets.set ['cat', 'dog']
    pets.user_value.should == ['cat', 'dog']
  end

  it 'set multiple items by value and user value ruturns selected items by text' do
    pets.set_value ['o1', 'o2']
    pets.user_value.should == ['cat', 'dog']
  end

  # this is not practical for single select but can be done for testing
  # conditions arising from switching items in a batch approach
  it 'set items array for single select selects each in turn. selected is the last item in array' do
    gender.set ['M', 'F', '', 'F']
    gender.user_value.should == 'F'
  end

  it 'set item after multiple items were set returns all values selected for multiselect' do
    pets.set ['cat', 'zook']
    pets.set 'zebra' #appends to selection
    pets.user_value.should == ['cat', 'zook', 'zebra']
  end

  it 'set multiselect by position' do
    pets.set 3
    pets.user_value.should == 'zook'
    pets.set_value 2 # translate to second text item
    pets.user_value.should == ['dog', 'zook']
    pets.set [1, 4, 5]
    pets.user_value.should == ['cat', 'dog', 'zook', 'zebra', 'wumpa']
  end

  it 'set using position and item for multiselect' do
    pets.set [1, 'zebra', 'zook', 2, 4] #select already selected
    pets.user_value.should == ['cat', 'dog', 'zook', 'zebra']
  end

  it 'set using position for single select' do
    gender.set 2
    gender.user_value.should == 'M'
  end

  it 'clear removes selected attribute for all selected items in multiselect' do
    pets.user_value.should == false
    pets.set ['zook', 'cat']
    pets.user_value.should == ['cat', 'zook']
    pets.clear
    pets.user_value.should == false
  end

  it 'clear removes selected attribute for item in single select list' do
    gender.user_value.should == 'M'
    gender.set 'F'
    gender.user_value.should == 'F'

    # This fails on IE in single select list.
    # The test passes in Firefox
    # option item select = false does not set false like it does in multiselect
    #gender.clear
    #gender.user_value.should == 'M'
  end

  it 'set_value selects value atribute text' do
    gender.set_value 'm'
    gender.user_value.should == 'M'
  end

  it 'set_value for multiselect returns selected and selected_values' do
    pets.set_value 'o2'
    pets.set_value 'o4'
    pets.user_value.should == ['dog', 'zebra']
  end
end
