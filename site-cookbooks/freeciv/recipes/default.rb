directory node['freeciv']['working_dir'] do
  action :create
end

template ::File.join(node['freeciv']['working_dir'], 'freeciv-web.project') do
  source 'freeciv-web.project'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
end

execute 'make and install freeciv' do
  user 'vagrant'
  cwd node['freeciv']['working_dir']
  command <<-EOH
    tar xzf #{node['freeciv']['arch_file']}
    mv #{'freeciv-' + ::File.basename(node['freeciv']['arch_file'], '.tar.gz')} freeciv
    cd freeciv
    ./autogen.sh #{node['freeciv']['configure_flags']}
    make -j$(nproc)
    make install
EOH
end

remote_file ::File.join(node['freeciv']['working_dir'], node['freeciv']['arch_file']) do
  action :create_if_missing
  source File.join(node['freeciv']['site_url'], node['freeciv']['arch_file'])
  notifies :run, 'execute[make and install freeciv]', :immediately
end

