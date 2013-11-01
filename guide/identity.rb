#
#
#   Identity check in JRuby
#
#
$LOAD_PATH << '../lib'
require 'jrzmq'
require './zhelpers.rb'

context = ZMQ::Context.new
uri = "inproc://example"

sink = context.socket(ZMQ::ROUTER)
sink.bind(uri)

# 0MQ will set the identity here
anonymous = context.socket(ZMQ::REQ)
anonymous.connect(uri)
anon_message = ZMQ::Message.new "Router uses a generated UUID"
anonymous.send(anon_message, 0)
s_dump(sink)

# Set the identity ourselves
identified = context.socket(ZMQ::REQ)
identified.setsockopt(ZMQ::IDENTITY, "PEER2".to_i)
identified.connect(uri)
identified_message = ZMQ::Message.new "Router uses socket identity"
identified.send(identified_message, 0)
s_dump(sink)

sink.close()
anonymous.close()
identified.close()
context.term()
