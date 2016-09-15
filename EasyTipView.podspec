Pod::Spec.new do |s|
  s.name = 'EasyTipView'
  s.version = '1.0.2'
  s.license = 'MIT'
  s.summary = 'Elegant tooltip view written in Swift'
  s.description = 'EasyTipView is a fully customisable tooltip view written in Swift that can be used as a call to action or informative tip. It can be shown above of below any UIBarItem or UIView subclass.'
  s.homepage = 'https://github.com/teodorpatras/EasyTipView'
  s.social_media_url = 'http://twitter.com/teodorpatras'
  s.authors = { 'Teodor Patraș' => 'me@teodorpatras.com' }
  s.source = { :git => 'https://github.com/teodorpatras/EasyTipView.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'

  s.requires_arc = true
end
