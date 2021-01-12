require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-snapkit"
  s.version      = package["version"]
  s.summary      = package["summary"]
  s.description  = <<-DESC
                  react-native-snapkit
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-snapkit"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Kane Thomas" => "kane@fadmania.com" }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/github_account/react-native-snapkit.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  # s.use_frameworks = true

  s.dependency "React"
  s.dependency "SnapSDK/SCSDKLoginKit", '1.6.9'
end

