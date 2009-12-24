# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{watirloo}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["marekj"]
  s.date = %q{2009-12-24}
  s.description = %q{Helps you write tests in the language of the customer's domain}
  s.email = %q{marekj.com@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "History.txt",
     "Manifest.txt",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/watirloo.rb",
     "lib/watirloo/browsers.rb",
     "lib/watirloo/desktop.rb",
     "lib/watirloo/extension/firewatir_ducktape.rb",
     "lib/watirloo/extension/object.rb",
     "lib/watirloo/extension/watir_ducktape.rb",
     "lib/watirloo/extension/watir_reflector.rb",
     "lib/watirloo/locker.rb",
     "lib/watirloo/page.rb",
     "script/console",
     "script/console.cmd",
     "script/destroy",
     "script/destroy.cmd",
     "script/generate",
     "script/generate.cmd",
     "script/reflect.rb",
     "spec/browser_spec.rb",
     "spec/browser_threads_spec.rb",
     "spec/checkbox_group_spec.rb",
     "spec/checkbox_groups_spec.rb",
     "spec/checkboxes_value_spec.rb",
     "spec/desktop_spec.rb",
     "spec/extra/browser_events_spec.rb",
     "spec/extra/page_objects_metrics.rb",
     "spec/face_mixing_spec.rb",
     "spec/firewatir/attach_instance_test.rb",
     "spec/firewatir/spec_results.html",
     "spec/firewatir/spec_results.txt",
     "spec/firewatir/spec_results_failed.txt",
     "spec/html/census.html",
     "spec/html/checkbox_group1.html",
     "spec/html/frameset1.html",
     "spec/html/labels.html",
     "spec/html/no_title.html",
     "spec/html/person.html",
     "spec/html/radio_group.html",
     "spec/html/select_lists.html",
     "spec/input_element_spec.rb",
     "spec/label_spec.rb",
     "spec/locker_spec.rb",
     "spec/page_spec.rb",
     "spec/person_def_wrappers_spec.rb",
     "spec/radio_group_spec.rb",
     "spec/radio_groups_spec.rb",
     "spec/reflector_spec.rb",
     "spec/select_list_options_spec.rb",
     "spec/select_lists_spec.rb",
     "spec/spec_helper.rb",
     "spec/spec_helper_ff.rb",
     "spec/spec_helper_runner.rb",
     "spec/spec_results.html",
     "spec/spec_results.txt",
     "spec/spec_results_failed.txt",
     "spec/text_fields_spec.rb",
     "watirloo.gemspec"
  ]
  s.homepage = %q{http://github.com/marekj/watirloo}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{small Watir framework based on semantic page object adapters for DOM elements}
  s.test_files = [
    "spec/browser_spec.rb",
     "spec/browser_threads_spec.rb",
     "spec/checkboxes_value_spec.rb",
     "spec/checkbox_groups_spec.rb",
     "spec/checkbox_group_spec.rb",
     "spec/desktop_spec.rb",
     "spec/extra/browser_events_spec.rb",
     "spec/extra/page_objects_metrics.rb",
     "spec/face_mixing_spec.rb",
     "spec/firewatir/attach_instance_test.rb",
     "spec/input_element_spec.rb",
     "spec/label_spec.rb",
     "spec/locker_spec.rb",
     "spec/page_spec.rb",
     "spec/person_def_wrappers_spec.rb",
     "spec/radio_groups_spec.rb",
     "spec/radio_group_spec.rb",
     "spec/reflector_spec.rb",
     "spec/select_lists_spec.rb",
     "spec/select_list_options_spec.rb",
     "spec/spec_helper.rb",
     "spec/spec_helper_ff.rb",
     "spec/spec_helper_runner.rb",
     "spec/text_fields_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<watir>, [">= 1.6.2"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.7"])
    else
      s.add_dependency(%q<watir>, [">= 1.6.2"])
      s.add_dependency(%q<rspec>, [">= 1.2.7"])
    end
  else
    s.add_dependency(%q<watir>, [">= 1.6.2"])
    s.add_dependency(%q<rspec>, [">= 1.2.7"])
  end
end

