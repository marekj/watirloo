require 'spec_helper'

context "Text Field enabled by Checkbox" do

  def browser
    Watirloo.browser
  end

  before :all do
    browser.goto testfile('person2.html')
  end

  class CheckboxTextField

    def initialize checkbox, text_field
      @checkbox = checkbox
      @text_field = text_field
    end

    def set value
      if value == false
        @checkbox.clear
      else
        @checkbox.set
        @text_field.set value
      end
    end

    def value
      @checkbox.checked? ? @text_field.value : false
    end
  end

  class Page
    include Watirloo::Page
  end

  class PersonPage < Page

    def cbx
      browser.checkbox(:id, "cbx")
    end

    def txt
      browser.text_field(:id, "txt")
    end

    def nickname
      CheckboxTextField.new cbx, txt
    end
  end

  specify "example" do

    page = PersonPage.new

    # the way we reason about :nickname in our tests is this
    page.set :nickname => 'rubytester' #turn it on and set the name
    page.nickname.value.should == 'rubytester'
    page.set :nickname => false # turn it off
    page.nickname.value.should == false
  end

end