require 'spec_helper'


describe 'page object' do

  include Watirloo::PageContainer

  before :all do
    browser.goto testfile('person.html')
  end

  it "should take block" do
    po = Watirloo::PageObject.new(:foo) { text_field(:name, 'first_nm') }
    pp po
    pp po.page_object.html
  end


  it "po" do
    po = Watirloo::PageObject.new(:foo) { text_field(:name, 'first_nm') }
    po2 = Watirloo::PageObject.new(:bla) { po }

    pp po.page_object
    #pp po.page_object.html
    po2.set "bla"
  end

  it 'field ' do
    class Bla
      def initialize po
        @po = po
      end

      def set
        @po.set
      end
    end
    class TestPage
      include Watirloo::Page
      field(:foo) { text_field(:name, 'first_nm') }
      field(:bla) { foo }
    end

    page = TestPage.new
    page.foo.set "foo"
    page.bla.set 'bla'
  end

end
