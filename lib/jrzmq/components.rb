
require 'zmq_classes'
require 'zmq_constants'

module ZMQ

  ########### DATA SERIALIZATION #########

  require 'edn'

  def read(data)
    EDN.read(data)
  end

  def write(data)
    data.to_edn
  end
  
end
