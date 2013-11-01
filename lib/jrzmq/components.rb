
require 'zmq_classes'
require 'zmq_constants'

module ZMQ

  ########### DATA SERIALIZATION #########

  require 'edn'

  module_function

  def read(data)
    EDN.read(data)
  end

  def write(data)
    data.to_edn
  end

  def poll(items, timeout)
    org.jeromq.ZMQ.poll(items, timeout)
  end

end
