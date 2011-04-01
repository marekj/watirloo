require 'spec_helper'

context "Phone Number as Domain Specific Page Object" do

  class PhoneParts
    include Watirloo::Page

    field(:phone1) { text_field(:id, "phone_1") }
    field(:phone2) { text_field(:id, "phone_2") }
    field(:phone3) { text_field(:id, "phone_3") }

    def set value
      area, sec3, sec4 = value.match(/\((\d+)\)(\d+)-(\d+)/).captures
      phone1.set area
      phone2.set sec3
      phone3.set sec4
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

    # text_field(:id, 'phone_n') # one watir object text field
    # phone is now 3 text_field objects (areacode) 3digits - 4digits
    # Let's invent a Domain Specific Page Object that responds to :set method
    field(:phone) { PhoneParts.new }

  end

  specify "example" do

    # we want to set value the same way no matter what implementation
    # of phone number page object
    page = PersonPage.new
    page.phone.set '(888)777-9999'
    page.set :phone => '(800)555-1212'

  end

end