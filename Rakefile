require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  # this currently does not work in rake 0.9.2, 0.9.3 will fix it
  # t.pattern = 'test/**/*_test.rb'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
end

task :default => :test
