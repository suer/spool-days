WORKSPACE="SpoolDays.xcworkspace"
SCHEME = "SpoolDays"
TMP = "tmp"
ARCHIVE = "$(pwd)/#{TMP}/#{SCHEME}"
IPA = "#{ARCHIVE}.ipa"
PRETTY = "bundle exec xcpretty"
ALTOOL = "$(xcode-select -p)/../Applications/Application\\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool"

class String
    def bold; "\033[1m#{self}\033[22m" end
end

task :clean do
    puts "🚮  Cleaning...".bold
    sh "rm -rf #{TMP} && mkdir #{TMP}"
end

task :archive => :clean do
    puts "🔨  Archiving...".bold
    sh "xcodebuild archive -workspace #{WORKSPACE} -scheme #{SCHEME} -archivePath #{ARCHIVE} | #{PRETTY}"
end

task :ipa => :archive do
    puts "📦  Creating ipa...".bold
    sh "xcrun -sdk iphoneos PackageApplication #{ARCHIVE}.xcarchive/Products/Applications/#{SCHEME}.app -o #{IPA}  -embed org.codefirst.SpoolDays.mobileprovision"
end

task :submit => :ipa do
    puts "🔌  Contacting to iTunes Connect...".bold

    require 'io/console'
    print "iTunes Connect ID or Email: "
    user = STDIN.gets.strip
    print "iTunes Connect Password: "
    password = STDIN.noecho(&:gets).strip
    puts ""

    puts "✈️  Submitting to TestFlight...".bold
    sh "#{ALTOOL} --upload-app --file #{IPA} --username #{user} --password #{password}", verbose: false

    puts "🎉  Submitted!".bold
end

