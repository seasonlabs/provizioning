package :ufw, :provides => :firewall do
  description "UFW Firewall"
  
  apt "ufw" do 
    post :install, "sudo ufw allow to 0.0.0.0/0 port 80"
    post :install, "sudo ufw allow to 0.0.0.0/0 port 443"
    post :install, "sudo ufw allow to 0.0.0.0/0 port 3000"
    post :install, "sudo ufw allow to 0.0.0.0/0 port 22"
    post :install, "sudo ufw allow to 0.0.0.0/0 port 25"
    post :install, "sudo ufw enable"
  end
end