%w[rubygems rake rake/clean fileutils newgem rubigen spec hoe].each { |f| require f }
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
    ['rspec', ">= #{::Spec::VERSION::STRING}"]
  ]
  p.test_globs  =['spec/*_spec.rb']
  p.testlib = ['spec']
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/, ''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }


require 'spec/rake/spectask'
desc "spec with ie browser"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.fail_on_error = false
  t.spec_opts = [
    #"--require spec/spec_helper_runner.rb", # slow execution expected
    "--format specdoc",
    "--format specdoc:spec/spec_results.txt",
    "--format failing_examples:spec/spec_results_failed.txt",
    "--format html:spec/spec_results.html",
    #"--diff",
    "--loadby mtime",
    #"--dry-run", # will overwrite any previous spec_results
    #"--generate-options spec/spec.opts",
  ]
end

# FIXME fix the spec FileList to only include those that execut for firefox. use taglog lib
desc "spec with ff browser"
Spec::Rake::SpecTask.new(:spec_ff) do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.spec_opts = [
    "--require spec/spec_helper_ff.rb",
    "--format specdoc",
    "--format specdoc:spec/firewatir/spec_results.txt",
    "--format failing_examples:spec/firewatir/spec_results_failed.txt",
    "--format html:spec/firewatir/spec_results.html",
    "--loadby mtime" ]
end

#task :default => :spec
