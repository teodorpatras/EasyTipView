Pod::Spec.new do |s|
  s.name = 'EasyTipView'  
  s.authors = { 'Teodor Patraș' => 'me@teodorpatras.com' }
  s.version = '1.0.4'
  s.license = 'MIT'
  s.summary = 'Elegant tooltip view written in Swift'
  s.description = 'EasyTipView is a fully customisable tooltip view written in Swift that can be used as a call to action or informative tip. It can be shown above of below any UIBarItem or UIView subclass.'
  s.homepage = 'https://github.com/sergeygarazha/EasyTipView'
  s.source = { :git => 'https://github.com/sergeygarazha/EasyTipView.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'

  s.requires_arc = true
end
