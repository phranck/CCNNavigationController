Pod::Spec.new do |s|
	s.name                  = 'CCNNavigationController'
	s.version               = '1.1.3'
	s.summary               = 'An Mac OS X Navigation Controller that acts mostly like the counter part on iOS - UINavigationController.'
	s.homepage              = 'https://github.com/phranck/CCNNavigationController'
	s.authors               = { 'Frank Gregor' => 'phranck@cocoanaut.com'}
	s.source                = { :git => 'https://github.com/phranck/CCNNavigationController.git', :tag => s.version.to_s }
	s.source_files          = 'CCNNavigationController/**/*.{h,m}'
	s.requires_arc          = true
	s.osx.deployment_target = '10.9'
	s.license               = { :type => 'MIT' }
end