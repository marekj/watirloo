require 'spec_helper'

describe "Page class with field definitions" do
  class Page1
    include Watirloo::Page
  end
  
  it 'has field method as singleton' do
    Page1.singleton_methods.should include('field')
  end

  it 'field class method defines method' do
    Page1.field(:bla) do
      "hello"
    end
    page = Page1.new
    page.should respond_to(:bla)
    page.bla.should == 'hello'
  end

  it 'field accepts args used by method body' do
    Page1.field(:foo) do |x|
      x * 2
    end
    page = Page1.new
    page.foo(2).should == 4
    page.foo("bla").should == "blabla"
  end

  it "when optional args not supplied provide default arg in method" do
    # this is a strange design decision. I want to provide method arg with default
    # example def bar(x=0) 
    Page1.field(:bar) do |*x|
      x = x[0] || 0
      x
    end
    page = Page1.new
    page.bar.should == 0
    page.bar(3).should == 3
  end
end

describe "Page class included in rspec" do

  include Watirloo::Page
  field(:lastname1) { text_field(:name, 'last_name0')}
  field(:lastname) {|nbr| text_field(:name, "last_name#{nbr+1}")}

  before do
    browser.goto testfile('census.html')
  end

  it 'using static field' do
    lastname1.set "Zippididuda"
    lastname1.value.should == 'Zippididuda'
  end

  it 'using field with arguments' do
    lastname(1).set "Zorro"
    lastname(1).value.should == "Zorro"
  end
end


describe "Page is a frame instead of default browser" do

  include Watirloo::Page
  field(:lastname1) {text_field(:name, 'last_name0')}
  field(:lastname) {|nbr| text_field(:name, "last_name#{nbr+1}")}

  before do
    browser.goto testfile('frameset1.html')
    self.page = browser.frame(:name,'census_frame')
  end

  it 'field defines a watir element access' do
    lastname1.set "Zippididuda"
    lastname1.value.should == 'Zippididuda'
  end

  it 'faces with arguments' do
    lastname(1).set "Zorro"
    lastname(1).value.should == "Zorro"
  end
end