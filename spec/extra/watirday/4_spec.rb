require 'spec_helper'

context "I want my test case data to tell page to populate objects" do

  def browser
    Watirloo.browser
  end

  before :all do
    browser.goto testfile('person2.html')
  end

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

    # in watirloo page method provides the receiver for instance_exec
    def page
      browser
    end

    # we want a method that will create a bridge between
    # customer vocabulary and watir object
    # I chose to use instance_exec mechanism (similar to instance_eval)
    # it packages code and executes at runtime where needed
    # opportunity to define whatever you need in your DSL page objects

    def self.field(name, *args, &definition)
      define_method(name) do |*args|
        page.instance_exec(*args, &definition)
      end
    end

#         :keyword    { object that can be set in DOM }
    field(:firstname) { text_field(:name, 'first_nm') }
    field(:lastname) { text_field(:name, 'last_nm') }
    field(:gender) { select_list(:name, 'sex_cd') }
    field(:phone) { text_field(:id, 'phone_n') }

    # This pattern is used in:
    # Taza: https://github.com/scudco/taza
    # Convio: not open sourced
    # Watirloo: https://github.com/marekj/watirloo
    # General Pattern
    #
    # class Page
    #   pageobject(:keyword) { watir object }
    # end
    #


  end


  specify "example" do

    # notice we no longer refer to watir api here
    # this code is all about popoulating page with values
    page = PersonPage.new browser
    page.set :firstname => 'Franz',
             :lastname => 'Ferdinand',
             :gender => 'M',
             :phone => '(800)555-1212'

  end

  specify "easy access to watir objects" do
    # but we can access watir objects as well
    # watir objects are not hidden
    page = PersonPage.new browser
    puts page.firstname.inspect #<Watir::TextField:0x4cc4e90 located=false how=:name what="first_nm">
    puts page.phone.inspect #<Watir::TextField:0x4cc4b34 located=false how=:id what="phone_n">
  end

end