require 'twitter_oauth'

print 'Consumer Key> '
consumer_key = gets.chomp

print 'Consumer Secret> '
consumer_secret = gets.chomp

t = TwitterOAuth::Client.new(
  :consumer_key => consumer_key,
  :consumer_secret => consumer_secret
)

req = t.request_token

puts 'OK'
puts "please access and get PIN: #{req.authorize_url}"
print 'PIN> '
pin = gets.to_i

acc = t.authorize(
  req.token,
  req.secret,
  :oauth_verifier => pin
)

puts "Authorized:    #{t.authorized?}"

puts "consumer_key: #{consumer_key}"
puts "consumer_secret: #{consumer_secret}"
puts "access_token: #{acc.token}"
puts "access_secret: #{acc.secret}"

