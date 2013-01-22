require 'rubygems'
require 'rubygems/package_task'
require 'rake/testtask'

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'bulksearch/version'

task :default => :test


#############################################################################
#
# Testing tasks
#
#############################################################################

Rake::TestTask.new do |t|
  t.options = "-v"
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb", "test/**/*_test.rb"]
end


#############################################################################
#
# Utility tasks
#
#############################################################################

task :console do
  sh "irb -I lib -r bulksearch"
end


#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release do
  puts ""
  print "Are you sure you want to relase BulkSearch #{BulkSearch::VERSION}? [y/N] "
  exit unless STDIN.gets.index(/y/i) == 0
  
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  
  # Build gem and upload
  sh "gem build bulksearch.gemspec"
  sh "gem push bulksearch-#{BulkSearch::VERSION}.gem"
  sh "rm bulksearch-#{BulkSearch::VERSION}.gem"
  
  # Commit
  sh "git commit --allow-empty -a -m 'v#{BulkSearch::VERSION}'"
  sh "git tag v#{BulkSearch::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{BulkSearch::VERSION}"
end
