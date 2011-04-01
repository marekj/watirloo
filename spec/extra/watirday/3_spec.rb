require 'spec_helper'

context "I want my test case data to tell page to populate objects" do

  def browser
    Watirloo.browser
  end

  before :all do
    browser.goto testfile('person2.html')
  end

  # refactor to Page class provide
  # common behavior to all pages
  class Page
    attr_accessor :browser

    def initialize browser
      @browser = browser
    end

    def set(hash)
      hash.each_pair do |field, value|
        self.send(field).set value
      end
    end

  end

  class PersonPage < Page

    def firstname
      browser.text_field(:name, 'first_nm')
    end

    def lastname
      browser.text_field(:name, 'last_nm')
    end

    def gender
      browser.select_list(:name, 'sex_cd')
    end
  end

  specify "example" do

    # This is how I think of my test data
    datamap = {:firstname => 'Franz',
               :lastname => 'Ferdinand',
               :gender => 'M'}

    page = PersonPage.new browser

    page.firstname.set datamap[:firstname]
    page.lastname.set datamap[:lastname]
    page.gender.set datamap[:gender]


    # I want the page to know how to set it
    page.set datamap

    # pass test data to the page to be set
    page = PersonPage.new browser
    page.set :firstname => 'Franz', :lastname => 'Ferdinand', :gender => 'M'

  end

end