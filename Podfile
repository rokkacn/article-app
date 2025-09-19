# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'ArticleApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ArticleApp
  
  # WeChat OpenSDK
  pod 'WechatOpenSDK', '~> 2.0.2'
  
  # Network
  pod 'Alamofire', '~> 5.0'
  
  # JSON Parsing
  pod 'SwiftyJSON', '~> 5.0'
  
  # Image Loading (if needed for remote images)
  pod 'Kingfisher', '~> 7.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end