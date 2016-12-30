# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

PROJECT_NAME = 'ChromaColorPicker-Demo'
TEST_TARGET = 'ChromaColorPickerTests'
SCHEME_FILE = 'ChromaColorPickerTests.xcscheme'

target TEST_TARGET do
  project PROJECT_NAME

  use_frameworks!
  inherit! :search_paths
  # Pods for ChromaColorPicker-Demo
  pod 'EarlGrey'
end

post_install do |installer|
  require 'earlgrey'
  configure_for_earlgrey(installer, PROJECT_NAME, TEST_TARGET, SCHEME_FILE)
end
