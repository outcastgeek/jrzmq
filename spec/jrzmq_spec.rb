require 'spec_helper'

describe ZMQ do
  context "#UPSTREAM_DOWNSTREAM" do
    it "sends two messages UPSTREAM and receives two messages DOWNSTREAM" do
      
      updown = Thread.new do
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
        received_msgs = []
        
        messages.each do |msg|
          outbound.send(msg)
        end

        loop do
          received_msg = inbound.recv_str
          puts "Received #{received_msg}"
          received_msgs << received_msg if received_msg != nil
          break if received_msg == "QUIT"
        end

        received_msgs.length.should == messages.length
        
        for i in 0..messages.length
          received_msgs[i].should == messages[i]
        end
      end

      updown.join
    end
  end
end
