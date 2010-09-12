package :rvm do
  description "Ruby Version Manager"
  run "bash < <( curl -L http://bit.ly/rvm-install-system-wide )"
  
  verify do 
    has_executable "rvm"
  end
end