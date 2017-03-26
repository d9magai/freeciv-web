package "maven" do
  action :install
  options '--no-install-recommends'
end

bash "mvn compile flyway:migrate" do
  cwd "/vagrant/freeciv-web"
  code <<-EOT
    cp flyway.properties.dist flyway.properties
    mvn compile flyway:migrate
  EOT
end

