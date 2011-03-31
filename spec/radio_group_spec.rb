require 'spec_helper'

describe 'RadioGroup class access in watir browser' do
  include Watirloo::Page

  before :each do
    browser.goto testfile('radio_group.html')
  end

  it 'browser responds to radio_group' do
    browser.should respond_to(:radio_group)
  end

  it 'radio group needs :what value with implicit :how=name' do
    rg = browser.radio_group('food')
    rg.size.should == 3
    rg.values.should == ['hotdog', 'burger', 'tofu']
  end
end

describe 'RadioGroup class interface in watirloo' do

  include Watirloo::Page
  field(:meals_to_go) { radio_group('food') }

  before do
    browser.goto testfile('radio_group.html')
  end

  it 'container radio_group method returns RadioGroup class' do
    # verify browser namespace explicitly
    if browser.kind_of?(FireWatir::Firefox)
      meals_to_go.should be_kind_of(FireWatir::RadioGroup)
    elsif browser.kind_of?(Watir::IE)
      meals_to_go.should be_kind_of(Watir::RadioGroup)
    end
  end

  it 'size or count returns how many radios in a group' do
    meals_to_go.size.should == 3
    meals_to_go.count.should == 3
  end

  it 'values returns value attributes text items as an array' do
    meals_to_go.values.should == ['hotdog', 'burger', 'tofu']
  end

  it 'user_value returns internal option value by default' do
    meals_to_go.user_value.should == 'burger'
  end

  it 'set selects radio by position in a group' do
    meals_to_go.set 3
    meals_to_go.user_value.should == 'tofu'

    meals_to_go.set 1
    meals_to_go.user_value.should == 'hotdog'
  end

  it 'set selects radio by value in a group. selected returns value' do
    meals_to_go.set 'hotdog'
    meals_to_go.user_value.should == 'hotdog'

    meals_to_go.set 'tofu'
    meals_to_go.user_value.should == 'tofu'
  end

  it 'set position throws exception if number not within the range of group size' do
    lambda { meals_to_go.set 7 }.should raise_error(Watir::Exception::WatirException)
  end

  it 'set value throws exception if value not found in options' do
    lambda { meals_to_go.set 'banannnanna' }.should raise_error(Watir::Exception::WatirException)
  end

  # TODO do I want to provide mapping of human generated semantic values for radios 
  # to actual values here in the radio_group or at the Watirllo level only? 
  it 'set throws exception if sybmol is used. it should accept Fixnum or String element only' do
    lambda { meals_to_go.set :yes }.should raise_error(Watir::Exception::WatirException)
  end

end