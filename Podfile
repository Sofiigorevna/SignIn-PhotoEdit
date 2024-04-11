source 'https://github.com/cocoapods/specs.git'

platform :ios, "13.0"
use_frameworks!

def available_pods

  # UI
 pod 'CropViewController' 
end

target "SignIn&PhotoEdit" do
  available_pods
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
          # M1 Simulator
          config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "x86_64"
          
          # Set deployment target to disable warnings
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
