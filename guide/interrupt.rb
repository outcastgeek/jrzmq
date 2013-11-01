# Shows how to handle Ctrl-C
$LOAD_PATH << '../lib'
require 'jrzmq'

context = ZMQ::Context.new(1)
socket = context.socket(ZMQ::REP)
socket.bind("tcp://*:5558")

trap("INT") { puts "Shutting down."; socket.close; context.term; exit}

puts "Starting up"

while true do
  message = socket.recv_str
  puts "Message: #{message.inspect}"
  socket.send("Message received")
end
