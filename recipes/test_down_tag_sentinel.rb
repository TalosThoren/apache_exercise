# Set a down-tag for a few minutes
log 'message' do
  message 'Sentinel setting down-tag.'
  level :info
end

tag( 'down-tag' )

sleep( 300 )

log 'message' do
  message 'Sentinel un-setting down-tag.'
  level :info
end
untag( 'down-tag' )
