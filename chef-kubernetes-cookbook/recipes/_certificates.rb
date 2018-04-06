version = ::Time.now.to_i
service_group = coobook_name.tr('_', '-') + '.' + node.chef_environment.tr('_', '')

file "#{Chef::Config['cache_path']}/ca.key" do
  content OpenSSL::PKey::RSA.new(2048).to_pem
  not_if { ::File.exist?("#{Chef::Config['cache_path']}/ca.key") }
  not_if { ::File.exist?('/hab/svc/kubernetes-cookbook/files/ca.key') }
  notifies :run, 'execute[upload-ca-key]', :immediately
end

execute 'upload-ca-key' do
  action :nothing
  command "hab file upload #{service_group} #{version} #{Chef::Config['cache_path']}/ca.key"
end

file "#{Chef::Config['cache_path']}/ca.pem" do
  content gen_ca.to_pem
  not_if { ::File.exist?("#{Chef::Config['cache_path']}/ca.pem") }
  not_if { ::File.exist?('/hab/svc/kubernetes-cookbook/files/ca.pem') }
  notifies :run, 'execute[upload-ca-cert]', :immediately
end

execute 'upload-ca-cert' do
  action :nothing
  command "hab file upload #{service_group} #{version} #{Chef::Config['cache_path']}/ca.pem"
end

file "#{Chef::Config['cache_path']}/kubernetes.key" do
  content OpenSSL::PKey::RSA.new(2048).to_pem
  not_if { ::File.exist?("#{Chef::Config['cache_path']}/kubernetes.key") }
  not_if { ::File.exist?('/hab/svc/kubernetes-cookbook/files/kubernetes.key') }
  notifies :run, 'execute[upload-kubernetes-key]', :immediately
end

execute 'upload-kubernetes-key' do
  action :nothing
  command "hab file upload #{service_group} #{version} #{Chef::Config['cache_path']}/kubernetes.key"
end

file "#{Chef::Config['cache_path']}/kubernetes.pem" do
  content gen_cert('kubernetes').to_pem
  not_if { ::File.exist?("#{Chef::Config['cache_path']}/kubernetes.pem") }
  not_if { ::File.exist?('/hab/svc/kubernetes-cookbook/files/kubernetes.pem') }
  notifies :run, 'execute[upload-kubernetes-cert]', :immediately
end

execute 'upload-kubernetes-cert' do
  action :nothing
  command "hab file upload #{service_group} #{version} #{Chef::Config['cache_path']}/kubernetes.pem"
end

file "/hab/svc/kubernetes-cookbook/files/#{node['hostname']}.key" do
  content OpenSSL::PKey::RSA.new(2048).to_pem
  not_if { ::File.exist?("/hab/svc/kubernetes-cookbook/files/#{node['hostname']}.key") }
end

file "/hab/svc/kubernetes-cookbook/files/#{node['hostname']}.pem" do
  content gen_cert(node['hostname']).to_pem
  not_if { ::File.exist?("/hab/svc/kubernetes-cookbook/files/#{node['hostname']}.pem") }
end
