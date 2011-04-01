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

    # Given I have some data for my test case
    # Last Name: 'Ferdinand'
    # First Name: 'Franz'
    # Gender: 'M'

    page = PersonPage.new browser
    page.set :firstname => 'Franz'
    page.set :lastname => 'Ferdinand'
    page.set :gender => 'M'

    datamap = {:firstname => 'Franz',
               :lastname => 'Ferdinand',
               :gender => 'M'}
    page.set datamap

  end

end