# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

#use_frameworks!

# Available pods

def available_pods
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/DynamicLinks'

  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  pod 'ObjectMapper', '3.3.0'
  pod 'SwiftyJSON'

  pod 'GoogleMaps'
  pod 'GooglePlacePicker'
  pod 'GooglePlaces'

  pod 'FBSDKCoreKit', '4.35.0'
  pod 'FBSDKLoginKit', '4.35.0'
  pod 'GoogleSignIn', '4.1.2'

  pod 'SVProgressHUD'
  pod 'HCSStarRatingView'
  pod 'IQKeyboardManagerSwift'
  pod 'NHRangeSlider'
  pod 'YouTubePlayer'
  pod 'GTProgressBar'
  pod 'iOSPhotoEditor'
  
  pod 'PanModal'
  pod 'STPopup'

  pod 'EmptyStateKit'
  pod 'Material'
  
  pod 'SDWebImage', '~>3.8'
  pod 'XLPagerTabStrip', '~> 8.0'

end

target 'EZAR' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  available_pods
end

post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
           end
      end
    end
  end