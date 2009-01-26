require File.dirname(__FILE__) + '/test_helper'

# testing single select and multiselect controls
describe "SelectList selections" do
  
  before do
    @page = Watirloo::Page.new
    @page.b.goto testfile('select_lists.html')
    @page.face(
      :pets => [:select_list, :name, 'animals'],
      :gender => [:select_list, :name, 'sex_cd'])
  end

  it 'selected returns preselected item in single select' do
    @page.gender.selected.should == '' # in single select "" is preselected
    @page.gender.selected_item.should == '' # in single select "" is preselected
    @page.gender.selected_items.should == ['']
  end
  
  it 'selected returns preselected item in single select' do
    @page.gender.selected_value.should == '' # in single select "" is preselected
    @page.gender.selected_values.should == ['']
  end

  
  it 'selected returns nil for none selected itesm in multi select' do
    @page.pets.selected.should == nil # in multiselect noting is selected
    @page.pets.selected_item.should == nil
    @page.pets.selected_items.should == [] # as array
  end

  it 'selected returns nil for none selected itesm in multi select' do
    @page.pets.selected_value.should == nil
    @page.pets.selected_values.should == [] # as array
  end
  
  it 'set and query option by text for multiselect when none selected' do
    @page.pets.set 'dog'
    @page.pets.selected.should == 'dog' #multi select one item selected
    @page.pets.selected_item.should == 'dog' #multi select one item selected
    @page.pets.selected_items.should == ['dog']
  end
  
  it 'set and query option by value for multiselect when none selected' do
    @page.pets.set_value 'o2'
    @page.pets.selected.should == 'dog' #multi select one item selected
    @page.pets.selected_value.should == 'o2' #multi select one item selected
    @page.pets.selected_values.should == ['o2']
  end

  it 'set and query option by text for single select' do
    @page.gender.set 'F'
    @page.gender.selected.should == 'F' # single select one item
    @page.gender.selected_item.should == 'F' # single select one item
    @page.gender.selected_items.should == ['F'] # single select one item
  end

  it 'set and query option by value for single select' do
    @page.gender.set_value 'f'
    @page.gender.selected.should == 'F'
    @page.gender.selected_value.should == 'f' # single select one item
    @page.gender.selected_values.should == ['f'] # single select one item
  end

  
  it 'set by text multple items for multiselect selects each item' do
    @page.pets.set ['cat', 'dog']
    @page.pets.selected.should == ['cat','dog']
    @page.pets.selected_item.should == ['cat','dog'] # bypass filter when more than one item
    @page.pets.selected_items.should == ['cat','dog']
  end

  it 'set by value multple items for multiselect selects each item' do
    @page.pets.set_value ['o1', 'o2']
    @page.pets.selected.should == ['cat','dog']
    @page.pets.selected_value.should == ['o1','o2'] # bypass filter when more than one item
    @page.pets.selected_value.should == ['o1','o2']
  end

  # this is not practical for single select but can be done for testing 
  # conditions arising from switching items in a batch approach
  it 'set items array for single select selects each in turn. selected is the last item in array' do
    @page.gender.set ['M', 'F', '','F']
    @page.gender.selected.should == 'F'
  end
  
  it 'set item after multiple items were set returns all values selected for multiselect' do
    @page.pets.set ['cat','zook']
    @page.pets.set 'zebra'
    @page.pets.selected.should == ['cat', 'zook', 'zebra']
    @page.pets.selected_values.should == ['o1', 'o3', 'o4']
  end
  
  it 'set using position for multiselect' do
    @page.pets.set 3
    @page.pets.selected.should == 'zook'
    @page.pets.set_value 2 # translate to second text item
    @page.pets.selected.should == ['dog', 'zook']
    @page.pets.set [1,4,5]
    @page.pets.selected.should == ['cat','dog','zook', 'zebra','wumpa']
  end
  
  it 'set using position and item for multiselect' do
    @page.pets.set [1,'zebra', 'zook', 2, 4] #select already selected
    @page.pets.selected.should == ['cat','dog','zook','zebra']
  end
  
  it 'set using position for single select' do
    @page.gender.set 2
    @page.gender.selected.should == 'M'
    @page.gender.selected_value.should == 'm'
  end
  
  it 'clear removes selected attribuet for all selected items in multiselect' do
    @page.pets.selected.should == nil
    @page.pets.set ['zook', 'cat']
    @page.pets.selected.should == ['cat','zook']
    @page.pets.clear
    @page.pets.selected.should == nil
  end

  it 'clear removes selected attribute for item in single select list' do
    @page.gender.selected.should == ''
    @page.gender.set 'F'
    @page.gender.selected.should == 'F'
    @page.gender.clear
    @page.gender.selected.should.not == 'F' # This fails on IE. it does not remove selected attribute from options
    # FIXME I think this is bug in Watir clearSelection method but only on ie
  end
  
  it 'set_value selects value atribute text' do
    @page.gender.set_value 'm'
    @page.gender.selected.should == 'M'
    @page.gender.selected_value.should == 'm' #when you know there is only one item expected
    @page.gender.selected_values.should == ['m'] # array of items
  end
  
  it 'set_value for multiselect returns selected and selected_values' do
    @page.pets.set_value 'o2'
    @page.pets.set_value 'o4'
    @page.pets.selected.should == ['dog', 'zebra']
    @page.pets.selected_value.should == ['o2', 'o4'] # if array then bypass filter
    @page.pets.selected_values.should == ['o2', 'o4'] # plural
  end
end
