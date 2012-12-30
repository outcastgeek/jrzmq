jrzmq [![Build Status](https://secure.travis-ci.org/outcastgeek/jrzmq.png?branch=master)](http://travis-ci.org/outcastgeek/jrzmq)
=====
Provides JRuby Bindings to a Pure Java implementation of libzmq (ZeroMQ).

Installation
============

jruby -S gem install jrzmq

example
=======

        require 'jrzmq'

        context = ZMQ::Context.new(1)

        puts "Opening connection for READ DOWNSTREAM"
        inbound = context.socket(ZMQ::UPSTREAM)
        inbound.bind("ipc://localconnection")
        inbound.set_receive_time_out 10

        puts "Opening connection for WRITE UPSTREAM"
        outbound = context.socket(ZMQ::DOWNSTREAM)
        outbound.connect("ipc://localconnection")
        outbound.set_send_time_out 10

        messages = %w{Hello  World! QUIT}
        
        messages.each do |msg|
          outbound.send(msg)
        end
          
        loop do
          received_msg = inbound.recv_str
          puts "Received #{received_msg}"
          break if received_msg == "QUIT"
        end

license
=======

Same as [JeroMQ](https://github.com/zeromq/jeromq "JeroMQ"):

[COPYING](https://github.com/zeromq/jeromq/blob/master/COPYING "COPYING")

[COPYING.LESSER](https://github.com/zeromq/jeromq/blob/master/COPYING.LESSER "COPYING.LESSER")
