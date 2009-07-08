require File.dirname(__FILE__) + '/test_helper'

describe "select lists defining in class, instance and subclass" do
  
  class SelectListPage < Watirloo::Page
    face :pets => [:select_list, :name, 'animals']
    face :gender => [:select_list, :name, 'sex_cd']
  end
  
  before do
    @page = SelectListPage.new
    @page.browser.goto testfile('select_lists.html')
  end
  
  it 'face method with key parameter to construct SelectList per browser implementation' do
    if @page.browser.kind_of?(FireWatir::Firefox)
      @page.pets.should be_kind_of(FireWatir::SelectList)
      @page.gender.should be_kind_of(FireWatir::SelectList)
      
    elsif @page.browser.kind_of? Watir::IE
      @page.pets.should be_kind_of(Watir::SelectList)
      @page.gender.should be_kind_of(Watir::SelectList)
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
    page.interfaces.keys.map{|k| k.to_s}.sort.should == ['gender', 'pets', 'toys']
    page.respond_to?(:toys).should == true
  end
  
end
