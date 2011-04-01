require 'spec_helper'

context "Page class collection of objects" do

  # make a Page class as a collection of adapters
  class PersonPage
    attr_accessor :browser

    def initialize browser
      @browser = browser
    end

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

  def browser
    Watirloo.browser
  end

  before :all do
    browser.goto testfile('person2.html')
  end

  specify "example" do

    page = PersonPage.new browser
    page.firstname.set 'Franz'
    page.lastname.set 'Ferdinand'
    page.gender.set 'M'

  end
end