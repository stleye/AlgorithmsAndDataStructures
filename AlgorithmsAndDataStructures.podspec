Pod::Spec.new do |spec|
  spec.name         = "AlgorithmsAndDataStructures"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of AlgorithmsAndDataStructures."
  spec.description  = <<-DESC
                   This SDK implements some algorithms and data structures
                   DESC
  spec.homepage     = "https://github.com/stleye/humileants-specs"
  spec.license      = { :type => "MIT" }
  spec.author             = { "Sebastian Tleye" => "stleye@gmail.com" }
  spec.source       = { :git => "https://github.com/stleye/AlgorithmsAndDataStructures.git", :tag => "0.0.1" }
  spec.source_files  = "AlgorithmsAndDataStructures", "AlgorithmsAndDataStructures/**/*.{h,m,swift}"
  spec.exclude_files = "AlgorithmsAndDataStructures/Exclude"
end
