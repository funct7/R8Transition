#
# Be sure to run `pod lib lint R8Transition.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'R8Transition'
  s.version          = '0.1.0'
  s.summary          = 'Create your custom transition the way UIKit intended you to.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library provides types that adopt confusing transition protocols that UIKit provides,
making it easy for clients to create custom transitions the way UIKit intends you to.

Unlike other transition related libraries that write up their own code to make things work,
which means users of the library need to learn the library first without knowing whether their use case is supported,
this library is more of a basic implementation of protocols that the UIKit requires,
providing the confusing boilerplate implementation and requiring only the parameters that users really care about.
                       DESC

  s.homepage         = 'https://github.com/funct7/R8Transition'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'funct7' => 'funct7.io@gmail.com' }
  s.source           = { :git => 'https://github.com/funct7/R8Transition.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'R8Transition/Classes/**/*'
  
  # s.resource_bundles = {
  #   'R8Transition' => ['R8Transition/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
