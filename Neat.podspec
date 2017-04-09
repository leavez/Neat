
Pod::Spec.new do |s|
  s.name             = 'Neat'
  s.version          = '0.1'
  s.summary          = 'Fix the line height problems of TextKit'
  s.description      = <<-DESC
Neat is a tool solve the line height problems when using TextKit on iOS.

Line heights (or the visual line sapcings) displayed by TextKit vary on different lines when mixing different languages in one text. It looks very ungraceful and breaks the beauty of text layout. A common example is Chinese-English mixed layout, and even English-emoji mix cannot escape!! UILabel and UITextView handle this very well. Neat make TextKit views look exactly the same to UILabel.
                       DESC

  s.homepage         = 'https://github.com/leavez/Neat'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Leavez' => 'gaoji@zhihu.com' }
  s.source           = { :git => 'https://github.com/leavez/Neat.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Neat/Classes/**/*'
  s.frameworks = 'UIKit'
end
