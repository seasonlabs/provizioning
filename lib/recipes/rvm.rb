package :rvm do
  description "Ruby Version Manager"
  
  runner "bash < <( curl -L http://bit.ly/rvm-install-system-wide )"
  
  verify do 
    has_executable "rvm"
  end
  
  #requires :rvm_ree
end

package :rvm_ree do
  description "REE in RVM"
  
  apt "vim" do
    pre :install, "rvm install ree"
    post :install, "rvm --default ree"
  end
  
  #verify do
  #end
end