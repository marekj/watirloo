require File.dirname(__FILE__) + '/test_helper'

describe 'RadioGroup class access in watir browser' do
  before :each do
    @page = Watirloo::Page.new
    @page.browser.goto testfile('radio_group.html')
  end
  
  it 'browser responds to radio_group' do
    @page.browser.respond_to?(:radio_group).should == true
  end
  
  it 'finds radio group on the page by default param name' do
    rg = @page.browser.radio_group('food')
    rg.size.should == 3
    rg.values.should == %w[hotdog burger tofu]
  end
  
  it 'finds radio group on the page by :name, param name explicitly' do
    rg = @page.browser.radio_group(:name, 'food')
    rg.size.should == 3
    rg.values.should == %w[hotdog burger tofu]
  end
  
  it 'finds the first radio group on the page by :index, 1' do
    rg = @page.browser.radio_group(:index, 1)
    rg.size.should == 3
    rg.values.should == %w[hotdog burger tofu]
    rg.name.should == 'food'
  end
  
  it 'finds the second group on the page by index, 2' do
    rg = @page.browser.radio_group(:index, 2)
    rg.size.should == 3
    rg.values.should == %w[hotdoga burgera tofua]
    rg.name.should == 'fooda'
  end
  
end


describe 'RadioGroup class interface in watirloo' do
  
  class RadioGroupPage < Watirloo::Page
    face :meals_to_go => [:radio_group, 'food']
  end

  before do
    @page = RadioGroupPage.new
    @page.browser.goto testfile('radio_group.html')
  end
  
  it 'container radio_group method returns RadioGroup class' do
    # verify browser namespace explicitly
    if @page.b.kind_of?(FireWatir::Firefox)
      @page.meals_to_go.kind_of?(FireWatir::RadioGroup).should.be true
      
    elsif @page.b.kind_of?(Watir::IE)
      @page.meals_to_go.kind_of?(Watir::RadioGroup).should.be true
    end
  end
  
  it 'size or count returns how many radios in a group' do
    @page.meals_to_go.size.should == 3
    @page.meals_to_go.count.should == 3
  end
  
  it 'values returns value attributes text items as an array' do
    @page.meals_to_go.values.should == ["hotdog", "burger", "tofu"]
  end
  
  it 'selected_value returns internal option value for selected radio item in a group' do 
    @page.meals_to_go.selected.should == 'burger'
    @page.meals_to_go.selected_value.should == 'burger'
    @page.meals_to_go.selected_values.should == ['burger'] # matches select_list api
  end
  
  it 'set selects radio by position in a group' do
    @page.meals_to_go.set 3
    @page.meals_to_go.selected.should == 'tofu'
    @page.meals_to_go.selected_value.should == 'tofu'
    @page.meals_to_go.selected_values.should == ['tofu']

    @page.meals_to_go.set 1
    @page.meals_to_go.selected.should == 'hotdog'
    @page.meals_to_go.selected_value.should == 'hotdog'
    @page.meals_to_go.selected_values.should == ['hotdog']
  end
  
  it 'set selects radio by value in a group' do
    @page.meals_to_go.set 'hotdog'
    @page.meals_to_go.selected.should == 'hotdog'

    @page.meals_to_go.set 'tofu'
    @page.meals_to_go.selected_value.should == 'tofu'
  end
  
  it 'set position throws exception if number not within the range of group size' do
    assert_raise(Watir::Exception::WatirException) do
      @page.meals_to_go.set 7
    end
  end
  
  it 'set value throws exception if value not found in options' do
    assert_raise(Watir::Exception::WatirException) do
      @page.meals_to_go.set 'banannnanna'
    end
  end
  
  # TODO do I want to provide mapping of human generated semantic values for radios 
  # to actual values here in the radio_group or at the Watirllo level only? 
  it 'set throws exception if other than Fixnum or String element is used' do
    assert_raise(Watir::Exception::WatirException)do
      @page.meals_to_go.set :yes
    end
  end

end