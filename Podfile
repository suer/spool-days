source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
inhibit_all_warnings!
use_frameworks!

def my_pods
  pod 'MagicalRecord'
  pod 'SWTableViewCell'
  pod 'RSDayFlow', :git => 'https://github.com/suer/RSDayFlow.git', :commit => 'efb97f8'
  pod "MTDates"
end

target 'SpoolDays' do
  my_pods
end
target 'SpoolDaysTests' do
  my_pods
end
target 'SpoolDaysTodayExtension' do
  my_pods
end

post_install do |installer|
  t = installer.pods_project.targets.find {|target| target.name == 'RSDayFlow'}
  t.build_configurations.each do |config|
    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ['$(inherited)', 'RSDF_APP_EXTENSION']
  end
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-SpoolDays/Pods-SpoolDays-acknowledgements.plist', 'SpoolDays/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
