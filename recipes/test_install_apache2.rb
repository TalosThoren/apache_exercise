# Install apache2 for kitchen tests

package 'apache2' do
  action :install
end

service 'apache2' do
  action :start
end
