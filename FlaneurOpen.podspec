#
# Be sure to run `pod lib lint FlaneurOpen.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlaneurOpen'
  s.version          = '0.11.0-beta'
  s.summary          = 'A collection of convenient classes for Swift iOS development.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A collection of convenient classes for Swift iOS development, including
MapKit extension, etc.
                       DESC

  s.homepage         = 'https://github.com/FlaneurApp/FlaneurOpen'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Flâneur' => 'dev@flaneurapp.com' }
  s.source           = { :git => 'https://github.com/FlaneurApp/FlaneurOpen.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/Classes/**/*'

  s.resource_bundles = {
    'FlaneurOpen' => "Sources/Assets/*"
  }

  s.pod_target_xcconfig = {
    'SWIFT_SWIFT3_OBJC_INFERENCE' => 'Default',
    'SWIFT_VERSION' => '4.0'
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  # Dependencies
  s.dependency 'Kingfisher', '~> 4.0' # Asynchronous image downloads
  s.dependency 'IGListKit', '~> 3.0' #IGListKit for managing collection views
  s.dependency 'FlaneurImagePicker', '~> 0.7'
end
