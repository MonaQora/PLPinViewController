#
# Be sure to run `pod lib lint PLPinViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'PLPinViewController'
s.version          = '0.1.7'
s.summary          = 'A simple pinlock controller'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#  s.description      = <<-DESC

s.homepage         = 'https://github.com/PitchLabsAsh/PLPinViewController'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Ash Thwaites' => 'ash@trypitch.com' }
s.source           = { :git => 'https://github.com/PitchLabsAsh/PLPinViewController.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '9.0'

s.source_files = 'PLPinViewController/Classes/**/*'

s.resource_bundles = {
'PLPinViewController' => ['PLPinViewController/Assets/**/*.{storyboard,xib,xcassets,json,imageset,png}']
}

s.public_header_files = 'PLPinViewController/Classes/**/*.h'
s.dependency 'PureLayout'
s.dependency 'PLForm'
end
