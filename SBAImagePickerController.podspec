Pod::Spec.new do |s|
  s.name         = "SBAImagePickerController"
  s.version      = "1.3"
  s.summary      = "An easy multiple image picker controller for photo library."
  s.homepage     = "https://github.com/shoaib-akhtar/SBAImagePickerController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Shoaib Akhtar" => "shoaib.akhtar1@live.com" }
  s.source       = { :git => "https://github.com/shoaib-akhtar/SBAImagePickerController.git", :branch => "master",
                     :tag => s.version.to_s }
  s.platform     = :ios, '11.0'
  s.requires_arc = true
  s.source_files = "SBAImagePickerController/*.swift"
  s.resource_bundles = { "SBAImagePickerController" => "SBAImagePickerController/*.{lproj,storyboard,png}" }
  s.resource = 'SBAImagePickerController/*.{storyboard,png}'
  s.frameworks   = 'Foundation', 'UIKit'
  s.swift_version = '5.0'
end
