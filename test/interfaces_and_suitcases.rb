require File.dirname(__FILE__) + '/test_helper'

class PersonInterfaces < Watirloo::Page
  interface(:last) {text_field(:name, 'last_nm')}
  
  interface(:last_by_form) do
    form(:id, 'person').text_field(:name, 'last_nm')
  end
  
  interface(:first) {text_field(:name, 'first_nm')}
end


describe "Person Page with def wrapper methods" do
  
  before :each do
    @page = PersonInterfaces.new
    @page.goto testfile('person.html')
  end
  
  it 'craps' do
    @page.last.class.should == Watir::TextField
    @page.last_by_form.class.should == Watir::TextField
    @page.first.class.should == Watir::TextField
#    @page.last.value.should == 'Wonkatonka'
#    @page.face(:last).value.should == 'Wonkatonka'
#    
#    @page.face(:last).set 'Oompaloompa'
#    @page.last.value.should == 'Oompaloompa'
    
  end

end