Pod::Spec.new do |spec|
  spec.name         = 'Strux'
  spec.version      = '1.0.0'
  spec.summary      = 'Data Structures in pure Swift'
  spec.authors      = { 'Rick Clark' => 'rick@scipioapps.com' }
  spec.description  = <<-DESC
  Well-tested, fully-documented, MIT-licensed data structures written in Swift
  that are compatible with Swift 4 and Swift 5.
  DESC
  spec.homepage     = 'https://github.com/Ricks/Strux'
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.source_files = 'Sources/Strux/*.swift'
  spec.requires_arc = true
  spec.source       = { :git => 'https://github.com/Ricks/Strux.git', :tag => spec.version }
  spec.swift_versions = 4.0, 4.1, 4.2, 5.0, 5.1, 5.2, 5.3
end
