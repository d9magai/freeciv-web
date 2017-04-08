include_recipe 'git'
source_dir = node['casperjs']['git']['source_dir']
source_url = node['casperjs']['git']['source_url']
source_ref = node['casperjs']['version']

git "#{source_dir}/casperjs" do
  repository source_url
  reference  source_ref
  action     :checkout
end

link '/usr/local/bin/casperjs' do
  if /^[01]\.[01](\.\d|-beta[123])?/.match(basename) then
    to "#{source_dir}/casperjs/rubybin/casperjs"
  else
    to "#{source_dir}/casperjs/bin/casperjs"
  end
end
