Dir["#{File.dirname(__FILE__)}/recipes/*.rb"].each { |package| 
  require package
}