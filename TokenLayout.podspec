Pod::Spec.new do |spec|
  spec.name                 = "TokenLayout"
  spec.version              = "0.1.0"
  spec.summary              = "TokenLayout"
  spec.homepage             = "https://github.com/nesium/TokenLayout.git"
  spec.license              = "MIT license"
  spec.author               = "Marc Bauer"
  spec.platform             = :ios, "9.0"
  spec.source               = { :git => "https://github.com/nesium/TokenLayout.git", :tag => "#{spec.version}" }
  spec.source_files         = "Sources/**/*.{swift,h,m}"
  spec.swift_version        = "5.2"
  spec.module_name          = "TokenLayout"
end
