#
#  Be sure to run `pod spec lint MJBaseViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "MJBaseViewController"
  s.version      = "0.0.1"
  s.summary      = "This module contain base class of view controller and some common use function."
  s.homepage     = "https://github.com/Musjoy-XiaoYang/MJBaseViewController"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Podul" => "ylpodul@gmail.com" }
  # Or just: s.author    = "Podul"
  # s.authors            = { "Podul" => "ylpodul@gmail.com" }
  # s.social_media_url   = "http://twitter.com/Podul"

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Musjoy-XiaoYang/MJBaseViewController.git", :tag => "v-#{s.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #
  s.source_files = 'MJBaseViewController/Classes/**/*'
end
