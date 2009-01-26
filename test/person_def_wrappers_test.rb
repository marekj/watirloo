require File.dirname(__FILE__) + '/test_helper'

# There are 3 ways of defining an interface
# 1. class level face hash definition
# 2 def semanticname wrapper created for element
# 3 or just delegate to the browsing with familiar watir api
class Person < Watirloo::Page

  # class level interfaces as definitions for Browser
  face :first => [:text_field, :name, 'first_nm']
  face :street => [:text_field, :name, 'addr1']

  # def wrapper with suggested semantic name returns dom element
  # these wrappers can provide specialized behavior on the page
  def last
    @b.text_field(:name, 'last_nm')
  end

  def dob
    @b.text_field(:name, 'dob')
  end

end


describe "Person Page interfaces defined by def wrappers and class definitions" do
  
  before :each do
    @page = Person.new
    @page.browser.goto testfile('person.html')
  end
  
  it 'calling face when there is wrapper method' do
    @page.last.set 'Wonkatonka'
    @page.last.value.should == 'Wonkatonka'
  end
  
  it 'calling interface when there is definition and no method' do
    @page.first.set 'Oompaloompa'
    @page.first.value.should == 'Oompaloompa'
  end
  
  it 'delegating to browser when there is no definition' do
    @page.select_list(:name, 'sex_cd').set 'F'
    @page.select_list(:name, 'sex_cd').selected.should == 'F'
  end
  
  it 'spray method by convetion has keys correspondig to interface names for watir elements' do
    mapping = {:street => '13 Sad Enchiladas Lane', :dob => '02/03/1977'}
    @page.spray mapping
    @page.street.value.should == mapping[:street]
    @page.dob.value.should == mapping[:dob]
  end
  
end
