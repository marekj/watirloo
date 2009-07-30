require File.dirname(__FILE__) + '/spec_helper'


#each collection can reflect the accessors and specs for its own members
describe 'reflext :text_fields' do

  include Watirloo::Page

  before do
    browser.goto testfile('person.html')
  end
  
  it 'text_fields.reflect each :text_field' do
    expected = ["face(:last_nm) {text_field(:name, \"last_nm\")}",
      "last_nm.value.should == \"Begoodnuffski\"",
      "face(:first_nm) {text_field(:name, \"first_nm\")}",
      "first_nm.value.should == \"Joanney\"",
      "face(:dob) {text_field(:name, \"dob\")}",
      "dob.value.should == \"05/09/1964\"",
      "face(:addr1) {text_field(:name, \"addr1\")}",
      "addr1.value.should == \"1600 Transylavnia Ave.\""]

    browser.text_fields.reflect.should == expected
  end
end



describe 'reflect :radio_groups' do

  include Watirloo::Page

  before do
    browser.goto testfile('radio_group.html')
  end
  
  it 'reflects each radio group' do

    expected = ["face(:food) {radio_group(\"food\")}",
      "food.values.should == [\"hotdog\", \"burger\", \"tofu\"]",
      "food.selected.should == \"burger\"",
      "face(:fooda) {radio_group(\"fooda\")}",
      "fooda.values.should == [\"hotdoga\", \"burgera\", \"tofua\", \"hotdoga_t\", \"burgera_t\", \"tofua_t\"]",
      "fooda.selected.should == \"tofua\""]

    # here the radio_group pics up the same named elemnets in two distinct form containers
    # this would be a bug if container is browser
    browser.radio_groups.reflect.should == expected

  end
end




describe 'reflect :checkbox_groups' do

  include Watirloo::Page

  before do
    browser.goto testfile('checkbox_group1.html')
  end
  
  it 'reflects each checkbox_group' do

    expected = ["face(:pets) {checkbox_group(\"pets\")}",
      "pets.values.should == [\"cat\", \"dog\", \"zook\", \"zebra\", \"wumpa\"]",
      "pets.selected.should == nil",
      "face(:single_indicator) {checkbox_group(\"singleIndicator\")}",
      "single_indicator.values.should == [\"on\"]",
      "single_indicator.selected.should == nil",
      "face(:petsa) {checkbox_group(\"petsa\")}",
      "petsa.values.should == [\"cata\", \"doga\", \"zooka\", \"zebraa\", \"wumpaa\"]",
      "petsa.selected.should == nil",
      "face(:single_indicatora) {checkbox_group(\"singleIndicatora\")}",
      "single_indicatora.values.should == [\"on\"]",
      "single_indicatora.selected.should == nil"]
        
    browser.checkbox_groups.reflect.should == expected
  end

end