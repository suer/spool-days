require 'xcjobs'

XCJobs::Build.new do |t|
  t.workspace = 'SpoolDays'
  t.scheme = 'SpoolDays'
  t.configuration = 'Release'
  t.build_dir = 'build'
  t.formatter = 'xcpretty -c'
end

XCJobs::Test.new do |t|
  t.workspace = 'SpoolDays'
  t.scheme = 'SpoolDays'
  t.configuration = 'Release'
  t.add_destination('name=iPhone 6,OS=8.1')
  t.formatter = 'xcpretty -c'
end
