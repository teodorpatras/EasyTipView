
Pod::Spec.new do |s|
  s.name             = "EasyTipView"
  s.version          = "0.1.0"
  s.summary          = "A short description of EasyTipView."
  s.description      = <<-DESC
                       An optional longer description of EasyTipView

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/teodorpatras/EasyTipView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  # s.author           = { "Ayush Goel" => "ayushgoel111@gmail.com" }
  s.source           = { :git => "https://github.com/teodorpatras/EasyTipView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'EasyTipView/*.swift'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
