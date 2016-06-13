Pod::Spec.new do |s|
  s.name         = "ZLTabBarController"
  s.version      = "0.1"
  s.summary      = "custom tabbarcontroller"
  s.homepage     = "https://github.com/zingwin/ZLTabBarController"
  s.license      = "MIT"
  s.author       = { "zwin" => "zuozuihaodezijizl@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zingwin/ZLTabBarController.git", :tag => "0.1" }
  s.framework    = "UIKit"
  s.source_files  =  'Classes', '**/Classes/*.{h,m}'
  s.requires_arc = true

  end  
  