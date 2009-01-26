require File.dirname(__FILE__) + '/test_helper'

describe "select lists defining in class, instance and subclass" do
  
  class SelectListPage < Watirloo::Page
    face :pets => [:select_list, :name, 'animals']
  end
  
  before do
    @page = SelectListPage.new
    @page.face :gender => [:select_list, :name, 'sex_cd']
    @page.browser.goto testfile('select_lists.html')
  end
  
  it 'face method with key parameter to construct SelectList per browser implementation' do
    if @page.browser.kind_of?(FireWatir::Firefox)
      @page.pets.kind_of?(FireWatir::SelectList).should == true
      @page.gender.kind_of?(FireWatir::SelectList).should == true
      
    elsif @page.browser.kind_of? Watir::IE
      @page.pets.kind_of?(Watir::SelectList).should == true
      @page.gender.kind_of?(Watir::SelectList).should == true
    end
  end
  
  it 'face(:facename) and browser.select_list access the same control' do
    @page.select_list(:name, 'sex_cd').values.should == @page.gender.values
    @page.select_list(:name, 'animals').values.should == @page.pets.values
  end
  
  it 'subclassing the page and adding new interface gets previous ' do
    class SelectListSub < SelectListPage
      face :toys => [:select_list, :name, 'bubel']
    end
    page = SelectListSub.new
    page.interfaces.keys.should == [:toys, :pets]
  end

end
