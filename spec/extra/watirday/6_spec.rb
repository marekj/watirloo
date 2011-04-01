require 'spec_helper'

context "Text Field enabled by Checkbox" do

  class CheckboxTextField

    include Watirloo::Page

    field(:cbx) { checkbox(:id, "cbx") }
    field(:txt) { text_field(:id, "txt") }

    def set value
      if value == false
        cbx.clear
      else
        cbx.set
        txt.set value
      end
    end
  end

  def browser
    Watirloo.browser
  end

  before :all do
    browser.goto testfile('person2.html')
  end

  class PersonPage
    include Watirloo::Page

    field(:twittername) { CheckboxTextField.new }
  end

  specify "example" do

    page = PersonPage.new
    page.twittername.set 'watir'
    page.set :twittername => 'rubytester'
    page.set :twittername => false

  end

end