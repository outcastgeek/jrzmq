# author: Oleg Sidorov <4pcbr> i4pcbr@gmail.com
# this code is licenced under the MIT/X11 licence.

require 'rubygems'
require 'jrzmq'

context = ZMQ::Context.new
frontend = context.socket(ZMQ::ROUTER)
backend = context.socket(ZMQ::DEALER)

frontend.bind('tcp://*:5559')
backend.bind('tcp://*:5560')

poller = ZMQ::Poller.new(nil, 2)
poller.register(frontend, ZMQ::POLLIN)
poller.register(backend, ZMQ::POLLIN)

loop do
  poller.poll()
  if poller.pollin(0)
    loop do
      message = frontend.recv_str
      more = frontend.has_receive_more
      backend.send(message, more ? ZMQ::SNDMORE : 0)
      break unless more
    end
  elsif poller.pollin(1)
    loop do
      message = backend.recv_str
      more = backend.has_receive_more
      frontend.send(message, more ? ZMQ::SNDMORE : 0)
      break unless more
    end
  end
end
