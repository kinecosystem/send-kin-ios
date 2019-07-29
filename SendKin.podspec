#
# Be sure to run `pod lib lint send-kin-module-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SendKin'
  s.version          = '0.1.0'
  s.summary          = 'Easily send Kin between apps'
  s.license          = { :type => 'Kin Ecosystem SDK License', :file => 'LICENSE.md' }
  s.author           = { 'Kin Foundation' => 'info@kin.org' }
  s.social_media_url  = 'https://twitter.com/kin_foundation'

  s.description      = <<-DESC
Allow users of your app to transfer Kin to/from their Kin wallets in other apps.
                       DESC
  s.source           = { :git => 'https://github.com/kinecosystem/send-kin-module-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'send-kin-module-ios/Classes/**/*'
  s.platform      = :ios, '9.0'
  s.swift_version = '5.0'

  s.resource_bundles = {
    'SendKin' => ['send-kin-module-ios/Assets/*']
  }
end
