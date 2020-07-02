# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def rx_swift
  pod 'RxSwift', '~> 5.0'
end

def rx_cocoa
  pod 'RxSwift', '~> 5.0'
end

target 'post sharing social media' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for post sharing social media

  target 'post sharing social mediaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'post sharing social mediaUITests' do
    # Pods for testing
  end
    
    # add the Firebase pod for Google Analytics
    pod 'Firebase/Analytics'
    # add pods for any other desired Firebase products
    # https://firebase.google.com/docs/ios/setup#available-pods
    pod 'RxDataSources', '~> 4.0'
    rx_swift
    rx_cocoa

end

target 'CoreDataRepository' do
   use_frameworks!
   rx_swift
   pod 'QueryKit'
   
   target 'CoreDataRepositoryTests' do
     inherit! :search_paths
   end
   
   
end
