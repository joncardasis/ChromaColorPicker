Pod::Spec.new do |s|
  s.name         = "ChromaColorPicker"
  s.version      = "2.0.17"
  s.summary      = "An intuitive iOS color picker built in Swift."
  s.swift_version = '5.0'

  s.description  = <<-DESC
  A Swift color picker UIControl which allows users to select color(s) on a color wheel. Supports multiple handles, an optional brightness slider, and can be customized.
                   DESC

  s.homepage     = "https://github.com/joncardasis/ChromaColorPicker"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "Jonathan Cardasis"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/joncardasis/ChromaColorPicker.git", :tag => "#{s.version}" }
  s.source_files  = "Source/**/*.swift"

end
