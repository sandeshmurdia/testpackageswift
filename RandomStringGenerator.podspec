Pod::Spec.new do |spec|
  spec.name         = "RandomStringGenerator"
  spec.version      = "1.0.0"
  spec.summary      = "A Swift library for generating random strings"
  spec.description  = <<-DESC
                   RandomStringGenerator is a Swift library that provides functionality to generate random strings of specified lengths.
                   DESC
  spec.homepage     = "https://github.com/sandeshmurdia/RandomStringGenerator"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Your Name" => "email@example.com" }
  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.0"
  
  # Distribution as a binary framework
  spec.vendored_frameworks = "RandomStringGenerator.xcframework"
  
  # Specify the source location - this will be your GitHub repo
  spec.source       = { :http => "https://github.com/sandeshmurdia/RandomStringGenerator/releases/download/1.0.0/RandomStringGenerator.xcframework.zip" }
end
