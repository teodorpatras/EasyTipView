Pod::Spec.new do |s|
  s.name = 'EasyTipView'
  s.version = '2.1.0'
  s.license = 'MIT'
  s.summary = 'Elegant tooltip view written in Swift'
  s.description = 'EasyTipView is a fully customisable tooltip view written in Swift that can be used as a call to action or informative tip. It can be shown above of below any UIBarItem or UIView subclass.'
  s.homepage = 'https://github.com/teodorpatras/EasyTipView'
  s.authors = { 'Teodor Patraș' => 'hello@teodorpatras.com' }
  s.source = { :git => 'https://github.com/teodorpatras/EasyTipView.git', :tag => s.version }
  
  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/EasyTipView/*.swift'

  s.requires_arc = true
end
