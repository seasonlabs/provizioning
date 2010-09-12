package :rvm do
  description "Ruby Version Manager"

  installer do
    post "bash < <( curl -L http://bit.ly/rvm-install-system-wide )"
  end
  
  verify do 
    has_executable "rvm"
  end
end