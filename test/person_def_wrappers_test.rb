require File.dirname(__FILE__) + '/test_helper'

class Person < Watirloo::Page
  interface :bla, [:text_field, 'name', 'last_nm']
end
# def wrappers with suggested semantic names for elements
class Person < Watirloo::Page
  
  def last
    @b.text_field(:name, 'last_nm')
  end

  def first
    @b.text_field(:name, 'first_nm')
  end

  def dob
    @b.text_field(:name, 'dob')
  end

  def street
    @b.text_field(:name, 'addr1')
  end
  
  def gender
    @b.select_list(:name, 'sex_cd')
  end
  
end


describe "Person Page with def wrapper methods" do
  
  before :each do
    @page = Person.new
    @page.b.goto testfile('person.html')
  end
  
  it 'calling face when there is wrapper method' do
    
    @page.last.set 'Wonkatonka'
    @page.last.value.should == 'Wonkatonka'
    @page.face(:last).value.should == 'Wonkatonka'
    
    @page.face(:last).set 'Oompaloompa'
    @page.last.value.should == 'Oompaloompa'
    
  end
  
  it 'spray using methods wrappers for watir elements' do
    mapping = {:street => '13 Sad Enchiladas Lane', :dob => '02/03/1977'}
    @page.spray mapping
    @page.street.value.should == mapping[:street]
    @page.dob.value.should == mapping[:dob]
  end
  
end


