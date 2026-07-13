platform :ios, '15.0'

target 'GitHub Users' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GitHub Users
    pod 'Alamofire'
    pod 'RxSwift', '6.5.0'
    pod 'RxCocoa', '6.5.0'
    pod 'RxDataSources'
    pod 'ReachabilitySwift'
    pod 'Kingfisher', '~> 6.0'
    pod 'lottie-ios'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
