#
#
#   Identity check in Ruby
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
anonymous = context.socket(ZMQ::DEALER)
anonymous.connect(uri)
anon_message = ZMQ::Message.new_string_msg("Router uses a generated UUID")
anon_message.send(anonymous)
s_dump(sink)

# Set the identity ourselves
identified = context.socket(ZMQ::DEALER)
identified.setsockopt(ZMQ::IDENTITY, "PEER2".to_i)
identified.connect(uri)
identified_message = ZMQ::Message.new_string_msg("Router uses socket identity")
identified_message.send(identified)
s_dump(sink)
