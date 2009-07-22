%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/watirloo'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('watirloo', Watirloo::VERSION) do |p|
  p.developer('marekj', 'marekj.com@gmail.com')
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.rubyforge_name       = p.name # TODO this is default value
  p.extra_deps         = [
    ['watir', '>= 1.6.2'],
  ]
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"],
    ['rspec', '>=1.2.6']
  ]
  p.test_globs  =['spec/*_spec.rb']
  p.testlib = ['rspec']
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/, ''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

require 'spec/rake/spectask'
desc "spec ie default"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['test/*_test.rb']
end

desc "run all tests on Firefox (config per FireWatir gem)"
task :test_ff do
  # all tests attach to an existing firefox browser
  # start browser with jssh option
  Watir::Browser.default='firefox'
  Watir::Browser.new
  tests = Dir["spec/*_spec.rb"]
  tests.each do |t|
    Watirloo::Browser.target = :firefox
    require t
  end
  # at the end of test you will have one extra browser
end

