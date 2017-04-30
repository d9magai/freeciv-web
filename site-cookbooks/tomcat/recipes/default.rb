ruby_block 'set permissions for tomcat dir' do
  block do
    require 'fileutils'
    FileUtils.chmod_R 0777, '/var/lib/tomcat8/webapps'
    FileUtils.chown 'www-data', 'www-data', '/var/lib/tomcat8/webapps'
  end
  action :run
end

ruby_block 'set permissions for tomcat dir' do
  block do
    require 'fileutils'
    FileUtils.chmod_R 0777, '/var/lib/tomcat8/logs'
  end
  action :run
end

%w[
  /var/lib/tomcat8/webapps/
  /var/lib/tomcat8/webapps/data/
  /var/lib/tomcat8/webapps/data/savegames
  /var/lib/tomcat8/webapps/data/savegames/pbem
].each do |path|
  directory path do
    owner 'www-data'
    group 'www-data'
    mode '0777'
  end
end

