SpoolDays
===========================

Build
---------------------------

### Required

* Xcode 7
* Bundler 1.7.4



### Build

    $ bundle install --path .bundle
    $ bundle exec pod install

open SpoolDays.xcworkspace with Xcode, and build.

### Test

    $ bundle install --path .bundle
    $ bundle exec rake clean test
