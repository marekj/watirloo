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
end

describe "Page faces included in rspec" do

    include Watirloo::Page
    face(:last1) {doc.text_field(:name, 'last_name0')}
    face(:last) {|nbr| doc.text_field(:name, "last_name#{nbr+1}")}

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