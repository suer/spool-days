# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'SpoolDays' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SpoolDays
  pod 'HorizonCalendar'

  target 'SpoolDaysTests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-SpoolDays/Pods-SpoolDays-acknowledgements.plist', 'SpoolDays/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

    # https://stackoverflow.com/a/75729977
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
        end
      end
    end
  end
end
