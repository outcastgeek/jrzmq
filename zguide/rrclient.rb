# author: Oleg Sidorov <4pcbr> i4pcbr@gmail.com
# this code is licenced under the MIT/X11 licence.

require 'rubygems'
require 'jrzmq'

context = ZMQ::Context.new
socket = context.socket(ZMQ::REQ)
socket.connect('tcp://localhost:5559')

10.times do |request|
  string = "Hello #{request}"
  socket.send(string)
  puts "Sending string [#{string}]"
  socket.recv_str(message = '')
  puts "Received reply #{request}[#{message}]"
end
