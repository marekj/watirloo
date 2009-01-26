# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{watirloo}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["marekj"]
  s.date = %q{2009-01-25}
  s.description = %q{Watir Framework and Helper based on Semantic Page Objects Modeling.  Helps you design tests expressing DOM elements and groups of elements  on the page as Semantic Page Objects rather than their DOM implementations. It is not a DSL but it helps you write human readable tests and hooks them up  to Watir browsers for implementation  Give it a try. You will like it.}
  s.email = ["marekj.com@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile.rb", "lib/watirloo.rb", "lib/watirloo/firewatir_ducktape.rb", "lib/watirloo/reflector.rb", "lib/watirloo/watir_ducktape.rb", "script/console", "script/console.cmd", "script/destroy", "script/destroy.cmd", "script/generate", "script/generate.cmd", "script/reflect.rb", "test/checkbox_group_test.rb", "test/checkboxes_value_test.rb", "test/firewatir/attach_instance_test.rb", "test/html/census.html", "test/html/checkbox_group1.html", "test/html/labels.html", "test/html/person.html", "test/html/radio_group.html", "test/html/select_lists.html", "test/interfaces_test.rb", "test/label_test.rb", "test/person_def_wrappers_test.rb", "test/radio_group_test.rb", "test/select_list_in_class_test.rb", "test/select_list_options_test.rb", "test/select_lists_test.rb", "test/test_helper.rb", "test/text_fields_test.rb", "watirloo.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://watirloo.testr.us}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{watirloo}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Watir Framework and Helper based on Semantic Page Objects Modeling}
  s.test_files = ["test/checkboxes_value_test.rb", "test/checkbox_group_test.rb", "test/interfaces_test.rb", "test/label_test.rb", "test/person_def_wrappers_test.rb", "test/radio_group_test.rb", "test/select_lists_test.rb", "test/select_list_in_class_test.rb", "test/select_list_options_test.rb", "test/text_fields_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<watir>, [">= 1.6.2"])
      s.add_development_dependency(%q<newgem>, [">= 1.2.1"])
      s.add_development_dependency(%q<test/spec>, [">= 0.9.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<watir>, [">= 1.6.2"])
      s.add_dependency(%q<newgem>, [">= 1.2.1"])
      s.add_dependency(%q<test/spec>, [">= 0.9.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<watir>, [">= 1.6.2"])
    s.add_dependency(%q<newgem>, [">= 1.2.1"])
    s.add_dependency(%q<test/spec>, [">= 0.9.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
