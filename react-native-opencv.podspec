require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = package['podName']
  s.version      = package['version']
  s.license      = package['license']
  s.homepage     = package['homepage']
  s.authors      = package['contributors'].flat_map { |author| { author['name'] => author['email'] } }
  s.summary      = package['description']
  s.source       = { :git => package['repository']['url'] }
  s.source_files = 'ios/*.{h,m,mm}'
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.dependency "React"
  s.dependency "OpenCV", '~> 3.4.2'

end

  
