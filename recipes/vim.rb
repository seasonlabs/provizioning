package :vim do
  description 'VIM Editor'
  apt "vim"
  
  verify do
    has_executable 'vim'
  end
end