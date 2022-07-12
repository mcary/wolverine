Gem::Specification.new do |s|
  s.name        = 'winsome_wolverine'

  s.version     = '0.2.0'
  s.date        = '2012-11-28'
  s.summary     = "Log file processor"
  s.description = "Library and DSL to process log files with "+
                    "a pipe-and-filter architecture"
  s.authors     = ["Marcel M. Cary"]
  s.email       = 'marcel@oak.homeunix.org'
  s.files       = Dir["README.textile", "lib/**/*.rb"]
  s.homepage    = 'http://github.com/mcary/wolverine'

  s.add_dependency("progressbar")

  # AR 5 depends on Ruby >= 2.2
  s.add_development_dependency("activerecord", "~> 5.2.8")
  s.add_development_dependency("sqlite3")
  s.add_development_dependency("rspec", ["~> 2.14.0"])
end
