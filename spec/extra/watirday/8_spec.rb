require 'spec_helper'

context "Text Field enabled by Checkbox" do

  class RadioGroupWithLabel
    include Watirloo::Page

    field(:radiogroup) { |name| radio_group(name) }
    field(:label_for_value) { |value| label(:text, value) }
    field(:label_name_for) { |id| label(:for, id) }

    def initialize name
      @group = radiogroup(name)
    end

    def set value
      id = label_for_value(value).for
      @group.find { |r| r.id == id }.set
    end

    def user_value
      label_name_for(@group.selected_radio.id).text
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

    field(:colorname) { RadioGroupWithLabel.new 'color_for' }
  end

  specify "example" do

    page = PersonPage.new
    page.colorname.user_value.should == 'Blue'
    page.colorname.set 'Red'
    page.colorname.user_value.should == 'Red'

  end

end