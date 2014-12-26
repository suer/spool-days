source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
inhibit_all_warnings!
pod 'MagicalRecord'
pod 'SWTableViewCell'
pod 'RSDayFlow', :git => 'https://github.com/suer/RSDayFlow.git'
pod 'RMUniversalAlert'
pod 'SplunkMint-iOS'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-acknowledgements.plist', 'SpoolDays/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
