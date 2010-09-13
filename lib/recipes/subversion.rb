package :subversion, :provides => :scm do
  description 'Subversion Version Control'
  apt 'subversion'
  
  verify do
    has_executable 'svn'
  end
end