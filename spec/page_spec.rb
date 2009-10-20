require File.dirname(__FILE__) + '/spec_helper'

describe "Page class with face definitions" do
  class Page1
    include Watirloo::Page
  end
  
  it 'has face method as singleton' do
    Page1.singleton_methods.should include('face')
  end

  it 'face class method defines method' do
    Page1.face(:bla) do
      "hello"
    end
    page = Page1.new
    page.should respond_to(:bla)
    page.bla.should == 'hello'
  end

  it 'face accepts args used by method body' do
    Page1.face(:foo) do |x|
      x * 2
    end
    page = Page1.new
    page.foo(2).should == 4
    page.foo("bla").should == "blabla"
  end

  it "when optional args not supplied provide default arg in method" do
    # this is a strange design decision. I want to provide method arg with default
    # example def bar(x=0) 
    Page1.face(:bar) do |*x|
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
  face(:last1) { text_field(:name, 'last_name0')}
  face(:last) {|nbr| text_field(:name, "last_name#{nbr+1}")}

  before do
    browser.goto testfile('census.html')
  end


  it 'face defines a watir element access' do
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
  face(:last1) {text_field(:name, 'last_name0')}
  face(:last) {|nbr| text_field(:name, "last_name#{nbr+1}")}

  before do
    browser.goto testfile('frameset1.html')
    self.page = browser.frame(:name,'census_frame')
  end


  it 'face defines a watir element access' do
    last1.set "Zippididuda"
    last1.value.should == 'Zippididuda'
  end

  it 'faces with arguments' do
    last(1).set "Zorro"
    last(1).value.should == "Zorro"
  end


end