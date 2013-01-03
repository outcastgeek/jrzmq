$LOAD_PATH << '../lib'
require 'jrzmq'

context = ZMQ::Context.new(1)

puts "Starting Hello World server..."

# socket to listen for clients
socket = context.socket(ZMQ::REP)
socket.bind("tcp://*:5555")

while true do
  # Wait for next request from client
  request = socket.recv_str

  puts "Received request. Data: #{request.inspect}"

  # Do some 'work'
  sleep 1

  # Send reply back to client
  socket.send("world")

end
