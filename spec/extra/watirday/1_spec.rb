require 'spec_helper'

context "start" do

  def browser
    Watirloo.browser
  end

  before :all do
    browser.goto testfile('person2.html')
  end

  example "watir objects as method wrappers" do

    # Given I have some data for my test case
    # :lastname => 'Franz'
    # :firstname => 'Ferdinand'
    # :gender => 'M'

    # using watir api I would ned to do start like this
    browser.text_field(:name, 'first_nm').set 'Franz'
    browser.text_field(:name, 'last_nm').set 'Ferdinand'

    # so I insert watir objects in a method
    # those are my watir object providers
    def firstname
      browser.text_field(:name, 'first_nm')
    end

    def lastname
      browser.text_field(:name, 'last_nm')
    end

    # But I want to use my test vocabulary as identifiers
    firstname.set 'Franz'
    lastname.set 'Ferdinand'

  end
end