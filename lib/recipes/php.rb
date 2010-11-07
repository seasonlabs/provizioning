package :php do
  description 'PHP Interpreter'
  apt 'php5 libapache2-mod-php5 php5-mysql php5-gd'

  verify do
    has_executable 'php'
  end
end