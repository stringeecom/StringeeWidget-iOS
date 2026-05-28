
Pod::Spec.new do |s|
  s.name             = 'StringeeWidget'
  s.version          = '0.2.2'
  s.summary          = 'Developed by Stringee'

  s.description      = <<-DESC
The Stringee platform, developed by Stringee, makes it easy to embed high-quality interactive video, voice, messaging, and screen sharing into web and mobile apps.
                       DESC

  s.homepage         = 'https://github.com/stringeecom/StringeeWidget-iOS'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Stringee' => 'info@stringee.com' }
  s.source           = { :http => 'https://github.com/stringeecom/StringeeWidget-iOS/releases/download/0.2.2/StringeeWidget.xcframework.zip' }

  s.ios.deployment_target = '13.0'

  s.source_files = 'StringeeWidget.xcframework/**/StringeeWidget.framework/Headers/*.h'
  s.public_header_files = 'StringeeWidget.xcframework/**/StringeeWidget.framework/Headers/*.h'

  s.vendored_frameworks = 'StringeeWidget.xcframework'
  s.dependency "Stringee", '2.0.2'

end
