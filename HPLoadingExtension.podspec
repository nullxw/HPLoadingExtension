Pod::Spec.new do |s|

  s.name         = "HPLoadingExtension"
  s.version      = "0.0.0"
  s.summary      = "HPTabBarController is loading extension for collection, table and scroll view to refresh data or continue loading"
  s.homepage     = "http://facebook.com/huyphams"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Huy Pham" => "duchuykun@gmail.com" }
  s.social_media_url   = "https://facebook.com/huyphams"
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/huyphams/HPLoadingExtension.git", :tag => "#{s.version}" }
  s.source_files  = "Class/*.{h,m}"
  s.requires_arc = true

end
