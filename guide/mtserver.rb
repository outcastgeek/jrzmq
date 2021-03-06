#
# Multithreaded Hello World server
#

$LOAD_PATH << '../lib'
require 'rubygems'
require 'jrzmq'

def worker_routine(context)
  # Socket to talk to dispatcher
  receiver = context.socket(ZMQ::REP)
  receiver.connect("inproc://workers")

  loop do 
    receiver.recv_str(string = '')
    puts "Received request: [#{string}]"
    # Do some 'work'
    sleep(1)
    # Send reply back to client
    receiver.send("world")
  end
end


context = ZMQ::Context.new

puts "Starting Hello World server..."

# socket to listen for clients
clients = context.socket(ZMQ::ROUTER)
clients.bind("tcp://*:5555")

# socket to talk to workers
workers = context.socket(ZMQ::DEALER)
workers.bind("inproc://workers")

# Launch pool of worker threads
5.times do 
  Thread.new{worker_routine(context)}
end

# Connect work threads to client threads via a queue
ZMQ::ZMQQueue.new(context,clients,workers)
