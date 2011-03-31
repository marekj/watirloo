require 'spec_helper'

describe "Example Person Page interfaces defined by def wrappers and page objects" do

  include Watirloo::Page
  # declare page objects
  field(:firstname) { text_field(:name, 'first_nm') }
  field(:street) { text_field(:name, 'addr1') }

  # def wrapper helper with suggested semantic name returns dom element
  # example before page objects
  def lastname
    browser.text_field(:name, 'last_nm')
  end

  def dob
    browser.text_field(:name, 'dob')
  end

  before :each do
    browser.goto testfile('person.html')
  end

  it 'calling field when there is wrapper method' do
    lastname.set 'Wonkatonka'
    lastname.value.should == 'Wonkatonka'
  end

  it 'calling interface when there is definition and no method' do
    firstname.set 'Oompaloompa'
    firstname.value.should == 'Oompaloompa'
  end

  it 'populate method by convetion has keys correspondig to interface names for watir elements' do
    datamap = {:street => '13 Sad Enchiladas Lane', :dob => '02/03/1977'}
    populate datamap
    street.value.should == datamap[:street]
    dob.value.should == datamap[:dob]
  end

end
