require 'spec_helper'

describe ZMQ do
  context "#UPSTREAM_DOWNSTREAM" do
    it "sends two messages UPSTREAM and receives two messages DOWNSTREAM" do

      context = ZMQ::Context.new(1)
      
      puts "Opening connection for READ DOWNSTREAM"
      inbound = context.socket(ZMQ::UPSTREAM)
      inbound.bind("ipc://localconnection")
      #inbound.set_receive_time_out 10

      puts "Opening connection for WRITE UPSTREAM"
      outbound = context.socket(ZMQ::DOWNSTREAM)
      outbound.connect("ipc://localconnection")
      #outbound.set_send_time_out 10

      hello = "Hello World!"
      quit = "QUIT"
      
      outbound.send(hello)
      outbound.send(quit)

      received_msg = inbound.recv_str
      puts "Received #{received_msg}"
      received_msg.should == hello

      received_msg = inbound.recv_str
      puts "Received #{received_msg}"
      received_msg.should == quit

      context.term
    end
  end
end
