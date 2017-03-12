%w{
  wikipedia
  tornado
}.each do |pkgname|
  bash "#{pkgname}" do
    code <<-EOT
      pip3 install #{pkgname}
    EOT
  end
end

bash "install mysql-connector-python" do
  code <<-EOT
    curl -L 'https://github.com/mysql/mysql-connector-python/archive/2.1.3.tar.gz' | tar xvz -C #{Chef::Config['file_cache_path']}
    cd #{Chef::Config['file_cache_path']}/mysql-connector-python-2.1.3
    python3 setup.py install
  EOT
end

