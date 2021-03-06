require File.dirname(__FILE__) + '/spec_helper'

describe "Person Page interfaces defined by def wrappers and class definitions" do

  include Watirloo::Page
  # declare accessing elements
  face(:first) { text_field(:name, 'first_nm') }
  face(:street) { text_field(:name, 'addr1') }

  # def wrapper helper with suggested semantic name returns dom element
  def last
    browser.text_field(:name, 'last_nm')
  end

  def dob
    browser.text_field(:name, 'dob')
  end
  
  before :each do
    browser.goto testfile('person.html')
  end
  
  it 'calling face when there is wrapper method' do
    last.set 'Wonkatonka'
    last.value.should == 'Wonkatonka'
  end
  
  it 'calling interface when there is definition and no method' do
    first.set 'Oompaloompa'
    first.value.should == 'Oompaloompa'
  end
  
  it 'spray method by convetion has keys correspondig to interface names for watir elements' do
    datamap = {:street => '13 Sad Enchiladas Lane', :dob => '02/03/1977'}
    spray datamap
    street.value.should == datamap[:street]
    dob.value.should == datamap[:dob]
  end
  
end
