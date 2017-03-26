
package 'nginx' do
  action :install
  options '--no-install-recommends'
end

service 'nginx' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :start, 'service[nginx]'
  notifies :reload, 'service[nginx]'
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :start, 'service[nginx]'
  notifies :reload, 'service[nginx]'
end

