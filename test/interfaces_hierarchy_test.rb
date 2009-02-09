require File.dirname(__FILE__) + '/test_helper'


describe "PersonalInfo Page interfaces defined in other classes" do

  # Examples of Interface usage in Watirloo
  # this Page defines interface to first and last name
  class FullName < Watirloo::Page
    interface :first => [:text_field, :name, 'first_nm']  
    interface :last => [:text_field, :name, 'last_nm']
  end

  # this Address Page defines street name
  class Address < Watirloo::Page
    interface :street => [:text_field, :name, 'addr1']
  end

  # this page is a composition of interfaces that may appear by themselves
  # as pages in an application. 
  # think of a Page as some container. It can be entire page or part of Page
  # This page is composed of interfaces that appear in Address, FullName
  # but become interface to PersonalInfo
  # method face is shortcut for interface
  class PersonalInfo < Watirloo::Page
    face Address.interfaces
    face FullName.interfaces
    face :dob => [:text_field, :name, 'dob']
    face :gender => [:select_list, :name, 'sex_cd']
  end
  
  before :each do
    @page = PersonalInfo.new
    @page.browser.goto testfile('person.html')
  end

  
  it 'had address interface from another class' do
    all_interfaces = {
      :first => [:text_field, :name, 'first_nm'],
      :last => [:text_field, :name, 'last_nm'],
      :street => [:text_field, :name, 'addr1'],
      :dob => [:text_field, :name, 'dob'],
      :gender => [:select_list, :name, 'sex_cd']
    }
    @page.interfaces.should == all_interfaces
  end

  it 'talks to the browser' do
    params = {
      :first => 'Inzynier', 
      :last => 'Maliniak', 
      :gender => 'M',
      :dob => '03/25/1956', 
      :street => '1313 Lucky Ave'
    }
    @page.spray params # send params to the page to enter the data
  end
end
