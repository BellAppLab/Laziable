Pod::Spec.new do |s|

  s.name                = "Laziable"
  s.version             = "1.0.1"
  s.summary             = "When 'lazy var' doesn't cut it, have a truly Lazy variable in Swift."
  s.screenshot          = "https://github.com/BellAppLab/Laziable/raw/master/Images/laziable.png"

  s.description         = <<-DESC
So you declared a `lazy var` in Swift thinking it would behave like lazily instantiated variables in good ol' Objective-C. You thought you would set them to `nil` and they would reconstruct themselves later on when needed.

You poor thing.

[They don't](https://stackoverflow.com/a/40847994).

So why not bring that awesomeness back to Swift in a very lightweight way?
                   DESC

  s.homepage            = "https://github.com/BellAppLab/Laziable"

  s.license             = { :type => "MIT", :file => "LICENSE" }

  s.author              = { "Bell App Lab" => "apps@bellapplab.com" }
  s.social_media_url    = "https://twitter.com/BellAppLab"

  s.ios.deployment_target     = "9.0"
  s.watchos.deployment_target = "3.0"
  s.osx.deployment_target     = "10.10"
  s.tvos.deployment_target    = "9.0"

  s.module_name         = 'Laziable'

  s.source              = { :git => "https://github.com/BellAppLab/Laziable.git", :tag => "#{s.version}" }

  s.source_files        = "Sources/Laziable"

  s.framework           = "Foundation"

end
