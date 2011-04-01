require 'spec_helper'

context "Phone Number as Domain Specific Page Object" do

  def browser
    Watirloo.browser
  end

  class Page
    include Watirloo::Page
  end

  before :all do
    browser.goto testfile('person2.html')
  end

  class PhoneParts
    def initialize p1, p2, p3
      @p1, @p2, @p3 = p1, p2, p3
    end

    def set value
      m = value.match(/\((\d+)\)(\d+)-(\d+)/).captures
      area, sec3, sec4 = m.captures
      @p1.set area
      @p2.set sec3
      @p3.set sec4
    end

    def value
      sprintf("(%s)%s-%s", @p1.value, @p2.value, @p3.value)
    end
  end

  class PersonPage < Page

    def phone
      browser.text_field(:id, 'phone_n')
    end

  end

  class PersonPage < Page

    def phonepart(i)
      browser.text_field(:id, "phone_#{i}")
    end

    # text_field(:id, 'phone_n') # one watir object text field
    # phone is now 3 text_field objects (areacode) 3digits - 4digits
    # Let's invent a Domain Specific Page Object that responds to :set method
    def phone
      PhoneParts.new phonepart(1), phonepart(2), phonepart(3)
    end
  end

  specify "example" do

    # I want to set value of phone no matter what implementation in DOM
    # I don't want implementation to dicatate how I think about my test
    # Implementation change should not dicated test change
    page = PersonPage.new
    page.set :phone => '(800)555-1212'
    page.phone.value.should == '(800)555-1212'

    page.phone.set '(888)777-9999'
    page.phone.value.should == '(888)777-9999'

    page.set :phone => '(800)555-1212'
    page.phone.value.should == '(800)555-1212'


  end

end