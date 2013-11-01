#
# Simple message queuing broke
# Same as request-reply broker but using QUEUE device
#
$LOAD_PATH << '../lib'
require 'rubygems'
require 'jrzmq'

context = ZMQ::Context.new

# Socket facing clients
frontend = context.socket(ZMQ::ROUTER)
frontend.bind('tcp://*:5559')

# Socket facing services
backend = context.socket(ZMQ::DEALER)
backend.bind('tcp://*:5560')

# Start built-in device
ZMQ::ZMQQueue.new(context,frontend,backend)
