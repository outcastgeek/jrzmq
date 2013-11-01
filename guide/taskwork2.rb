#
#   Task worker - design 2
#   Adds pub-sub flow to receive and respond to kill signal
#

require 'rubygems'
require 'jrzmq'

context = ZMQ::Context.new(1)

# Socket to receive messages on
receiver = context.socket(ZMQ::PULL)
receiver.connect("tcp://localhost:5557")

# Socket to send messages to
sender = context.socket(ZMQ::PUSH)
sender.connect("tcp://localhost:5558")

# Socket for control input
controller = context.socket(ZMQ::SUB)
controller.connect("tcp://localhost:5559")
controller.setsockopt(ZMQ::SUBSCRIBE,"")

# Process messages from receiver and controller
poller = ZMQ::Poller.new(nil, 2)
poller.register(receiver,ZMQ::POLLIN)
poller.register(controller,ZMQ::POLLIN)

# Process tasks forever
while true
  poller.poll()
  if poller.pollin(0)
    msec = receiver.recv_str

    # Simple progress indicator for the viewer
    $stdout << "#{msec}."
    $stdout.flush

    # Do the work
    sleep(msec.to_f / 1000)

    # Send results to sink
    sender.send("")
  end

  exit if poller.pollin(1)
end
