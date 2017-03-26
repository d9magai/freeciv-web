
template '/vagrant/publite2/settings.ini' do
  source 'settings.ini'
  owner 'vagrant'
  group 'vagrant'
  mode "777"
end

template '/vagrant/freeciv-web/src/main/webapp/META-INF/context.xml' do
  source 'context.xml'
  owner 'vagrant'
  group 'vagrant'
  mode "777"
end

template '/vagrant/freeciv-web/src/main/webapp/WEB-INF/config.properties' do
  source 'config.properties'
  owner 'vagrant'
  group 'vagrant'
  mode "777"
end

