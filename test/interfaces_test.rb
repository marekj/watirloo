require File.dirname(__FILE__) + '/test_helper'


describe "SuperPage" do

  class SuperPage < Watirloo::Page
    interface 'name' => 'vname'
  end
  
  it 'class interface' do
    SuperPage.interfaces.keys.should == ['name']
  end
  
  it 'instance initialized from class interface' do
    page = SuperPage.new
    page.interfaces.keys.should == ['name']
    page.respond_to?('name').should == true
  end
end

describe "SuperPage and SubPage" do
  
  class Page0 < Watirloo::Page
    interface 'higher' => 'vhigher'
  end
  class Page1 < Page0
    interface 'lower' => 'vlower'
  end
  
  it 'Subpage inherits from Super its interfaces' do
    Page1.interfaces.keys.sort.should == %w[higher lower]
    p1 = Page1.new
    p1.interfaces.keys.sort.should == %w[higher lower]
    p1.respond_to?(:higher).should == true
    p1.respond_to?(:lower).should == true
  end
  
  it "Super retains its interfaces and is not affected by Subpages" do
    Page0.interfaces.keys.sort.should == ['higher']
    p0 = Page0.new
    p0.interfaces.keys.sort.should == %w[higher]
    p0.respond_to?(:higher).should == true
  end
  
  class Page3 < Watirloo::Page
    interface Page1.interfaces # pull interfaces into this class from other class
    interface 'included' => 'vincluded'
  end
  
  it 'Page3 gets interfaces include from Page0' do
    Page3.interfaces.keys.sort.should == %w[higher included lower]
    page = Page3.new
    page.respond_to?(:higher).should == true
    page.respond_to?(:included).should == true
    page.respond_to?(:lower).should == true
  end
end
