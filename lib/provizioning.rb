Dir["#{File.dirname(__FILE__)}/recipes/*.rb"].each do |package|
  require package
end