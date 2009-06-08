require File.dirname(__FILE__) + '/test_helper'


describe "SuperPage" do

  class SuperPage < Watirloo::Page
    face 'name' => 'vname'
  end
  
  it 'class interface' do
    SuperPage.interfaces.keys.should == ['name']
  end
  
  it 'instance initialized from class interface' do
    SuperPage.new.interfaces.keys.should == ['name']
  end
  
  it 'adding interface to instance adds interface to initialize' do
    page = SuperPage.new
    page.face 'sub' => 'sub' # add new face to instance
    page.interfaces.keys.sort.should == %w[name sub] # instance has now two
  end
  
  it 'but not to class' do
    page = SuperPage.new
    page.face 'sub' => 'sub'
    page.interfaces.keys.sort.should == %w[name sub]
    SuperPage.interfaces.keys.should == ['name'] # but the class has still only one
  end
  
  it 'class interface can be updated' do
    SuperPage.interfaces.update 'update' => 'vupdate'
    SuperPage.interfaces.keys.sort.should == %w[name update]
  end
  
  it 'instance gets interfaces from class but does not get them after updating class' do
    page = SuperPage.new
    page.interfaces.keys.sort.should == %w[name update] #previous example altered it
    SuperPage.interfaces.update 'muddy' => 'vmuddy'
    page.interfaces.keys.sort.should == %w[name update] #previous example altered it
  end
end

describe "SuperPage and SubPage" do
  
  class Page0 < Watirloo::Page
    face 'higher' => 'vhigher'
  end
  class Page1 < Page0
    face 'lower' => 'vlower'
  end
  class Page2 < Page1
    face 'lowest' => 'vlowest'
  end
  
  it 'Subpage inherits from Super its interfaces' do
    p1 = Page1.new
    p1.interfaces.keys.sort.should == %w[higher lower]
    p1.respond_to?(:higher).should == true
    p1.respond_to?(:lower).should == true
  end
  
  it "Super retains its interfaces and is not affected by Subpages" do
    p0 = Page0.new
    p0.face 'supinst' => 'vsupinst'
    p0.interfaces.keys.sort.should == %w[higher supinst]
    Page0.interfaces.keys.sort.should == ['higher']
    
    p1 = Page1.new
    p1.face 'subinst' => 'vsubinst'
    p1.interfaces.keys.sort.should == %w[higher lower subinst]
    Page1.interfaces.keys.sort.should == %w[higher lower]
    
    # extra checks
    p0.interfaces.keys.sort.should == %w[higher supinst] #super not affected by Sub
    Page0.interfaces.keys.sort.should == ['higher'] #not affected by P1.instance face
    Page2.interfaces.keys.sort.should == %w[higher lower lowest]
  end
  
  
end