require 'spec_helper'

describe ZMQ do
  context "#UPSTREAM_DOWNSTREAM" do
    it "sends two messages UPSTREAM and receives two messages DOWNSTREAM" do

      hello = "Hello World!"
      quit = "QUIT"

      received_msg1 = nil
      received_msg2 = nil
      
      updown = Thread.new do
        context = ZMQ::Context.new(1)

        puts "Opening connection for READ DOWNSTREAM"
        inbound = context.socket(ZMQ::UPSTREAM)
        inbound.bind("ipc://localconnection")
        #inbound.set_receive_time_out 10

        puts "Opening connection for WRITE UPSTREAM"
        outbound = context.socket(ZMQ::DOWNSTREAM)
        outbound.connect("ipc://localconnection")
        #outbound.set_send_time_out 10

        outbound.send(hello)
        outbound.send(quit)

        received_msg1 = inbound.recv_str
        puts "Received #{received_msg1}"

        received_msg2 = inbound.recv_str
        puts "Received #{received_msg2}"

        #context.term
      end

      updown.join
      received_msg1.should == hello
      received_msg2.should == quit
    end
  end
end
