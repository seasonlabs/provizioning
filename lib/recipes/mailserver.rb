#Not sure if this recipe will work because exim has its own pseudo-gui installer
package :postfix, :provides => :mailserver do
  description 'Postfix MTA'
  apt 'postfix'

  verify do
    has_executable 'postfix'
  end
end