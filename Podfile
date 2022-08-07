# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SpoolDays' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SpoolDays
  pod 'MagicalRecord'
  pod 'RSDayFlow', :git => 'https://github.com/suer/RSDayFlow.git', :commit => 'efb97f8'
  pod "MTDates"

  target 'SpoolDaysTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SpoolDaysTodayExtension' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
    t = installer.pods_project.targets.find {|target| target.name == 'RSDayFlow'}
    t.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ['$(inherited)', 'RSDF_APP_EXTENSION']
    end
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-SpoolDays/Pods-SpoolDays-acknowledgements.plist', 'SpoolDays/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
