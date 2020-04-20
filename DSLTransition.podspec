Pod::Spec.new do |s|

  s.name         = "DSLTransition"
  s.version      = "1.0.1"
  s.summary      = "多种自定义present转场，效果实用，使用方便"
  s.homepage     = "https://github.com/dengshunlai/DSLTransition"
  s.license      = "MIT"
  s.author       = { "邓顺来" => "mu3305495@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/dengshunlai/DSLTransition.git", :tag => "v#{s.version}" }
  s.source_files = "DSLTransition/**/*.{h,m}"
  s.requires_arc = true

end
