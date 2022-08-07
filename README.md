SpoolDays
===========================

Build
---------------------------

### Required

* Xcode 13.2.1
* Bundler 1.17.2



### Build

    $ bundle install --path .bundle
    $ bundle exec pod install

open SpoolDays.xcworkspace with Xcode, and build.

### Test

    $ bundle install --path .bundle
    $ bundle exec rake clean test
