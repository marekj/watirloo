require 'spec_helper'

describe "add faces text fields page objects" do

  include Watirloo::Page

  field(:lastname) { text_field(:name, 'last_nm') }
  field(:firstname) { text_field(:name, 'first_nm') }

  before do
    browser.goto testfile('person.html')
  end

  it 'field returns a watir element text_field' do
    if browser.kind_of? FireWatir::Firefox
      firstname.should be_kind_of(FireWatir::TextField)
      lastname.should be_kind_of(FireWatir::TextField)
    elsif browser.kind_of? Watir::IE
      firstname.should be_kind_of(Watir::TextField)
      lastname.should be_kind_of(Watir::TextField)
    end
  end

  it 'field name method and value returns current text' do
    firstname.value.should == 'Joanney'
    lastname.value.should == 'Begoodnuffski'
  end

  it 'scrape fieldname gets its value' do
    scrape(:firstname).should == {:firstname => 'Joanney'}
  end

  it 'scrape fieldnames gets datamap' do
    data = scrape [:firstname, :lastname]
    data.values.sort.should == ['Begoodnuffski', 'Joanney']
  end

  it "field.set enters value into field" do
    params = {:firstname => 'Grzegorz', :lastname => 'Brzeczyszczykiewicz'}
    firstname.set params[:firstname]
    lastname.set params[:lastname]
    firstname.value.should == params[:firstname]
    lastname.value.should == params[:lastname]
  end

  it 'populate matches keys as fields and sets values to fields' do
    params = {:firstname => 'Grzegorz', :lastname => 'Brzeczyszczykiewicz'}
    populate params
    firstname.value.should == params[:firstname]
    lastname.value.should == params[:lastname]
  end

  it 'scrape keys updates keys with values and returns datamap' do
    datamap = {:firstname => 'Hermenegilda', :lastname => 'Kociubinska'}
    populate datamap
    values = scrape datamap.keys
    values.should == datamap
  end
end
 