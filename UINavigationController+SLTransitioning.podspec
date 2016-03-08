Pod::Spec.new do |s|
  s.name         = "UINavigationController+SLTransitioning"
  s.version      = "1.0.0"
  s.summary      = "A category of UINavigationController containing multiple transitioning styles."
  s.homepage     = "https://github.com/Soul-Beats/UINavigationController-SLTransitioning"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Soul-Beats" => "lilingfengzero@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Soul-Beats/UINavigationController-SLTransitioning.git", :tag => s.version }
  s.source_files  = "Source/*.{h,m}"
  s.requires_arc = true
  
  s.subspec 'AnimatedTransitionings' do |at|
  at.source_files = 'Source/AnimatedTransitionings/**/*.{h,m}'
  end
end
