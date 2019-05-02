fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios test_and_publish
```
fastlane ios test_and_publish
```
Runs unit tests, publishing a new pod version if tests succeed.
### ios publish_pod
```
fastlane ios publish_pod
```
Publish podspec, incrementing the patch version.
### ios test
```
fastlane ios test
```
Runs unit tests.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
