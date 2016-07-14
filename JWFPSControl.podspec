
Pod::Spec.new do |s|


  s.name         = "JWFPSControl"
  s.version      = "0.0.1"
  s.summary      = "一款实时展示当前屏幕FPS的控件，使用简单。"

  #主页
  s.homepage     = "https://github.com/junwangInChina/JWFPSControl"
  #证书申明
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  #作者
  s.author       = { "wangjun" => "github_work@163.com" }
  #支持版本
  s.platform     = :ios, "7.0"

  #版本地址
  s.source       = { :git => "https://github.com/junwangInChina/JWFPSControl.git", :tag => "0.0.1" }

  #库文件路径（相对于.podspec文件的路径）
  s.source_files  = "JWFPSControlDemo/JWFPSControlDemo/JWFPSControl/**/*.{h,m}"

  #是否支持arc
  s.requires_arc = true


end
