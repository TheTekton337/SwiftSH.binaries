Pod::Spec.new do |spec|
  spec.name         = 'SwiftSH'
  spec.version = '0.3.0'
  spec.summary      = 'A Swift SSH framework that wraps libssh2, packaged as a binary for convenience.'
  spec.description  = <<-DESC
                       SwiftSH is a powerful library that enables SSH communication in Swift applications. This podspec is designed to integrate precompiled SwiftSH binaries for ease of use and rapid integration into iOS and macOS projects.
                     DESC
  spec.homepage     = 'https://github.com/TheTekton337/SwiftSH.binaries'
  spec.license      = 'MIT'
  spec.author       = { 'Tommaso Madonia' => 'tommaso@madonia.me' }
  spec.platforms    = { :ios => '13.0', :osx => '10.15' } # Adjust based on the platforms you support
  spec.swift_version = '5.3'
  spec.source       = { :http => 'https://github.com/TheTekton337/SwiftSH.binaries/releases/download/#{spec.version}/SwiftSH.xcframework.zip' }
  spec.vendored_frameworks = 'SwiftSH.xcframework'

  spec.dependency 'CSSH', '~> 1.11.0'
end
