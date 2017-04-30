execute 'build' do
  user 'vagrant'
  cwd node['freeciv-web']['path']
  command <<-EOH
    mvn package
    cp target/freeciv-web.war /var/lib/tomcat8/webapps/ROOT.war
    date >> src/main/webapp/build.txt
  EOH
end

