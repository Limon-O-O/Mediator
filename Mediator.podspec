Pod::Spec.new do |s|

  s.name        = "Mediator"
  s.version     = "0.0.5"
  s.summary     = "Mediator."

  s.description = <<-DESC
                  This is Mediator
                   DESC

  s.homepage    = "https://github.com/Limon-O-O/Mediator"

  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.author      = { "Limon" => "fengninglong@gmail.com" }
  s.social_media_url  = "https://twitter.com/Limon______"

  s.ios.deployment_target   = "8.0"

  s.source          = { :git => "https://github.com/Limon-O-O/Mediator.git", :tag => s.version }
  s.source_files    = "Mediator/*.swift"
  s.requires_arc    = true

end
