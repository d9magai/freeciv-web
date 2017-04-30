execute 'build' do
  user 'vagrant'
  cwd node['freeciv-web']['path']
  command <<-EOH
    cp #{node['freeciv']['path']}/freeciv/data/scenarios/*.sav /var/lib/tomcat8/webapps/data/savegames/
    mvn package
    cp target/freeciv-web.war /var/lib/tomcat8/webapps/ROOT.war
    date >> src/main/webapp/build.txt
  EOH
end

