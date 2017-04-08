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

