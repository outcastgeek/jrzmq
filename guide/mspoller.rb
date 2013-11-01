# author: Oleg Sidorov <4pcbr> i4pcbr@gmail.com
# this code is licenced under the MIT/X11 licence.
#
# Reading from multiple sockets
# This version uses a polling

$LOAD_PATH << '../lib'
require 'rubygems'
require 'jrzmq'

context = ZMQ::Context.new

# Connect to task ventilator
receiver = context.socket(ZMQ::PULL)
receiver.connect('tcp://localhost:5557')

# Connect to weather server
subscriber = context.socket(ZMQ::SUB)
subscriber.connect('tcp://localhost:5556')
subscriber.setsockopt(ZMQ::SUBSCRIBE, '10001')

# Initialize a poll set
poller = ZMQ::Poller.new(nil, 2)
poller.register(receiver, ZMQ::POLLIN)
poller.register(subscriber, ZMQ::POLLIN)

while true
  poller.poll()
  if poller.pollin(0)
    message = receiver.recv_str
    # process task
    puts "task: #{message}"

  elsif poller.pollin(1)
    message = subscriber.recv_str
    # process weather update
    puts "weather: #{message}"
  end
end
