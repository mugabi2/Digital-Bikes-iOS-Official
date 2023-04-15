# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Digital Bikes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Digital Bikes
  pod 'Alamofire'
  pod 'Imaginary'
  pod 'IQKeyboardManagerSwift'
  pod 'SKCountryPicker'
  pod 'FlagPhoneNumber'
  pod 'BFRImageViewer'
  pod 'SwiftyJSON'
  pod 'YPImagePicker'
  pod 'DropDown'
  pod 'SwiftTheme'
  pod 'SwiftEventBus'
  pod 'FlutterwaveSDK'
  pod 'PusherSwift'
  
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'FirebaseMessaging'
  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'GoogleMaps'
  
  pod "Agrume"

  
  
  
  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                 end
            end
     end
  end

  target 'Digital BikesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Digital BikesUITests' do
    # Pods for testing
  end

end
