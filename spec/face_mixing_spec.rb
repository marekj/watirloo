require 'spec_helper'


describe "Class client mixing interfaces from other modules" do

  # Examples of Interface usage in Watirloo
  # define interface to first and last name
  module FullName
    include Watirloo::Page
    field(:first) { text_field(:name, 'first_nm') }
    field(:last) { text_field(:name, 'last_nm') }
  end

  # this Address defines street name
  module Address
    include Watirloo::Page
    field :street do
      text_field(:name, 'addr1')
    end
  end

  # this page is a composition of interfaces that may appear by themselves
  # as pages in an application.
  # think of a Page as some container. It can be entire page or part of Page
  # This page is composed of interfaces that appear in Address, FullName
  # but become interface to PersonalInfo
  # method field is shortcut for interface
  class PersonalInfo
    include Address
    include FullName
    include Watirloo::Page
    field(:dob) { text_field(:name, 'dob') }
    field(:gender) { select_list(:name, 'sex_cd') }
  end


  before :each do
    @page = PersonalInfo.new
    @page.browser.goto testfile('person.html')
  end

  it 'populate and scrape example' do
    data = {
      :first => 'Inzynier',
      :last => 'Maliniak',
      :gender => 'M',
      :dob => '03/25/1956',
      :street => '1313 Lucky Ave'
    }
    @page.populate data # send params to the page to enter the data
    data_return = @page.scrape data.keys
    data_return.should == data
  end
end

