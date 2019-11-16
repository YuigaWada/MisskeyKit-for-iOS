Pod::Spec.new do |s|
s.name         = "MisskeyKit"
s.version      = "0.4"
s.summary      = "An elegant Misskey framework written in Swift."
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.homepage     = "https://github.com/yuigawada/MisskeyKit-for-iOS"
s.author       = { "YuigaWada" => "yuigawada@gmail.com" }
s.source       = { :git => "https://github.com/yuigawada/MisskeyKit-for-iOS.git", :tag => "#{s.version}" }
s.dependency 'Starscream'
s.platform     = :ios, "11.0"
s.requires_arc = true
s.source_files = 'MisskeyKit/**/*.{swift,h}'
s.resources    = 'MisskeyKit/**/*.{json}'
s.swift_version = "5.0"
end