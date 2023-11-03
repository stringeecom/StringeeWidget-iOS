
Pod::Spec.new do |s|
  s.name             = 'StringeeWidget'
  s.version          = '0.1.8'
  s.summary          = 'Developed by Stringee'

  s.description      = <<-DESC
The Stringee platform, developed by Stringee, makes it easy to embed high-quality interactive video, voice, messaging, and screen sharing into web and mobile apps.
                       DESC

  s.homepage         = 'https://github.com/stringeecom/StringeeWidget-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stringee' => 'info@stringee.com' }
  s.source           = { :git => 'https://github.com/stringeecom/StringeeWidget-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'StringeeWidget/Classes/**/StringeeWidget.framework/Headers/*.h'
  s.public_header_files = 'StringeeWidget/Classes/**/StringeeWidget.framework/Headers/*.h'

  s.vendored_frameworks = 'StringeeWidget/Classes/**/StringeeWidget.framework'
  s.dependency "Stringee", '1.9.21'

end
