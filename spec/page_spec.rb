require File.dirname(__FILE__) + '/spec_helper'

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

describe "Page faces included in rspec" do

  include Watirloo::Page
  field(:last1) { text_field(:name, 'last_name0')}
  field(:last) {|nbr| text_field(:name, "last_name#{nbr+1}")}

  before do
    browser.goto testfile('census.html')
  end


  it 'field defines a watir element access' do
    last1.set "Zippididuda"
    last1.value.should == 'Zippididuda'
  end

  it 'faces with arguments' do
    last(1).set "Zorro"
    last(1).value.should == "Zorro"
  end


end


describe "Page doc provides access to frame in frameset browser" do

  include Watirloo::Page
  field(:last1) {text_field(:name, 'last_name0')}
  field(:last) {|nbr| text_field(:name, "last_name#{nbr+1}")}

  before do
    browser.goto testfile('frameset1.html')
    self.page = browser.frame(:name,'census_frame')
  end


  it 'field defines a watir element access' do
    last1.set "Zippididuda"
    last1.value.should == 'Zippididuda'
  end

  it 'faces with arguments' do
    last(1).set "Zorro"
    last(1).value.should == "Zorro"
  end


end