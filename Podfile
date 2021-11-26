source 'https://github.com/CocoaPods/Specs.git'
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_base_pods
  pod 'RealmSwift'
end

target 'citysquare' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for citysquare
  shared_base_pods

  target 'citysquareTests' do
    inherit! :search_paths
    # Pods for testing
    shared_base_pods
  end

  target 'citysquareUITests' do
    # Pods for testing
    shared_base_pods
  end

end
