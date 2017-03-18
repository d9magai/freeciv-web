package "maven" do
  action :install
  options '--no-install-recommends'
end

bash "mvn compile flyway:migrate" do
  cwd "/vagrant/freeciv-web"
  code <<-EOT
    mvn compile flyway:migrate
  EOT
end

