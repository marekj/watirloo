require 'spec_helper'

describe 'setting and getting values for individual checkboxes with value attributes in field definitions' do

  # in watir you have to access each checkbox, we now have checkbox_group for this
  # in Watirloo you can access CheckboxGroup as shortcut using
  # :pets => [:checkbox_group, 'pets']
  include Watirloo::Page
  field(:pets_cat) { checkbox(:name, 'pets', 'cat') }
  field(:pets_dog) { checkbox(:name, 'pets', 'dog') }
  field(:pets_zook) { checkbox(:name, 'pets', 'zook') }
  field(:pets_zebra) { checkbox(:name, 'pets', 'zebra') }
  field(:pets_wumpa) { checkbox(:name, 'pets', 'wumpa') }

  before do
    browser.goto testfile('checkbox_group1.html')
  end

  it 'semantic name accesses individual CheckBox' do
    if browser.kind_of?(FireWatir::Firefox)
      pets_cat.should be_kind_of(FireWatir::CheckBox)

    elsif browser.kind_of?(Watir::IE)
      pets_cat.should be_kind_of(Watir::CheckBox)
    end
  end

  it 'set individual checkbox does not set other checkboxes sharing the same name' do
    pets_dog.should_not be_checked
    pets_dog.set true
    pets_dog.should be_checked
    pets_cat.should_not be_checked
  end

end
