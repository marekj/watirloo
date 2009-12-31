require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "watirloo"
    gem.summary = %Q{small Watir framework based on semantic page object adapters for DOM elements}
    gem.description = %Q{Helps you write tests in the language of the customer's domain}
    gem.email = "marekj.com@gmail.com"
    gem.homepage = "http://github.com/marekj/watirloo"
    gem.authors = ["marekj"]
    gem.add_dependency 'watir', '>=1.6.2'
    gem.add_development_dependency 'rspec', '>= 1.2.7'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


require 'spec/rake/spectask'
desc "spec with ie browser"
Spec::Rake::SpecTask.new do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/*_spec.rb']
  spec.spec_files.exclude('spec/reflector*') #TODO fix reflector feature
  spec.fail_on_error = false
  spec.rcov = true
  spec.rcov_opts = ["--text-report", "--exclude spec"]
  spec.spec_opts = [
    "--color",
    #"--require spec/spec_helper_runner.rb", # slow execution expected. closes all browsers on desktop before :all
    "--format specdoc",
    "--format specdoc:spec/results/ie.txt",
    "--format failing_examples:spec/results/ie-failed.txt",
    "--format html:spec/results/ie.html",
    #"--diff",
    "--loadby mtime",
    #"--dry-run", # will overwrite any previous spec_results
    #"--generate-options spec/spec.opts",
  ]
end


require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "watirloo #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# FireFox
namespace :ff do
 
  # FIXME fix the spec FileList to only include those that execut for firefox. use taglog lib
  desc "spec with ff browser"
  Spec::Rake::SpecTask.new do |spec|
    spec.spec_files = ['spec/page_spec.rb']
    #FIXME bug in SpecTask? when [] or spec_files omitted then it reads the default **/*_spec.rb list of files
    #if I include at least one spec files above the rest of the files are added from spec.opts
    spec.spec_opts = ["--options spec/ff.opts"]
    spec.rcov = true
    spec.rcov_opts = ["--text-report", "--exclude spec"]
  end

  desc "tasklist firefox.exe"
  task :tasklist do
    sh "tasklist /FI \"IMAGENAME eq firefox.exe\""
  end

  desc "taskkill firefox.exe tree"
  task :taskkill do
    sh "taskkill /f /t /im firefox.exe"
  end

  desc "start firefox with jssh"
  task :start do
    require 'firewatir'
    FireWatir::Firefox.new
  end
end

desc "start irb and load current lib/watirloo"
task :console do
  puts "START IRB for current project"
  this_dir = File.expand_path(File.join(File.dirname(__FILE__)))
  this_irbrc = File.join(this_dir, '_irbrc')
  this_lib = File.join(this_dir, 'lib')
  sh "set IRBRC=#{this_irbrc} && irb -I #{this_lib}"
  # do not read ~/.irbrc for other defaults
  # see ./_irbrc for what's loaded into irb and modify to your liking
end