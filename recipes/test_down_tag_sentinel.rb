# Set a down-tag for a few minutes
log 'message' do
  message 'Sentinel setting down-tag.'
  level :info
end

tag( 'down-tag' )
