# Does the down-tag currently exist on any apache2 nodes?
def downtag_exists()
  return !search( :node, 'tags:down-tag' ).empty?
end

result = downtag_exists

log 'message' do
  message "OUTPUT FROM DOWNTAG_EXISTS: #{result}"
  level :info
end

# If other node has down-tag, wait a while and check again
while downtag_exists do
  log 'message' do
    message 'down-tag currently exists, waiting 15 seconds'
    level :info
  end
  sleep(15)
end

# Set down-tag if no other nodes have set a down-tag
log 'message' do
  message 'No down-tag found, creating down-tag'
  level :info
end
tag( 'down-tag' )

# Update all files found in files/etc/apache2
remote_directory '/etc/apache2' do
  source 'apache2'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Restart apache2
service 'apache2' do
  action :restart
end

# Unset down-tag 
log 'message' do
  message 'Apache2 restart complete, removing down-tag'
  level :info
end
untag( 'down-tag' )
