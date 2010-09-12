package :curl do
  description 'Curl tool'
  apt 'curl'
  
  verify do
    has_executable 'curl'
  end
end