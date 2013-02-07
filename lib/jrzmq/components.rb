
module ZMQ

  require_jars(%w(jeromq))

  java_import 'zmq.ZMQ'

  class Socket < org.jeromq.ZMQ::Socket
    def setsockopt(opt, val)
      self.set_linger val
    end
  end

  class Context < org.jeromq.ZMQ::Context
    def initialize(ioThreads=java.lang.Runtime.getRuntime.availableProcessors)
      super(ioThreads)
    end

    def socket(type)
      Socket.new(self, type)
    end
  end

  class Poller < org.jeromq.ZMQ::Poller
  end

  class Message < org.jeromq.ZMsg
  end

  SNDMORE = org.jeromq.ZMQ::SNDMORE

  DONTWAIT = org.jeromq.ZMQ::DONTWAIT

  NOBLOCK = org.jeromq.ZMQ::NOBLOCK

  PAIR = org.jeromq.ZMQ::PAIR

  PUB = org.jeromq.ZMQ::PUB

  SUB = org.jeromq.ZMQ::SUB

  REQ = org.jeromq.ZMQ::REQ

  REP = org.jeromq.ZMQ::REP

  DEALER = org.jeromq.ZMQ::DEALER

  XREQ = org.jeromq.ZMQ::XREQ

  ROUTER = org.jeromq.ZMQ::ROUTER

  XREP = org.jeromq.ZMQ::XREP

  PULL = org.jeromq.ZMQ::PULL

  PUSH = org.jeromq.ZMQ::PUSH

  XPUB = org.jeromq.ZMQ::XPUB

  XSUB = org.jeromq.ZMQ::XSUB

  STREAMER = org.jeromq.ZMQ::STREAMER

  FORWARDER = org.jeromq.ZMQ::FORWARDER

  QUEUE = org.jeromq.ZMQ::QUEUE

  UPSTREAM = org.jeromq.ZMQ::UPSTREAM
    
  DOWNSTREAM = org.jeromq.ZMQ::DOWNSTREAM
    
  POLLIN = org.jeromq.ZMQ::POLLIN
    
  POLLOUT = org.jeromq.ZMQ::POLLOUT
    
  POLLERR = org.jeromq.ZMQ::POLLERR
=begin  
  EVENT_CONNECTED = org.jeromq.ZMQ::EVENT_CONNECTED

  EVENT_DELAYED = org.jeromq.ZMQ::EVENT_DELAYED
    
  EVENT_RETRIED = org.jeromq.ZMQ::EVENT_RETRIED
    
  EVENT_CONNECT_FAILED = org.jeromq.ZMQ::EVENT_CONNECT_FAILED
    
  EVENT_LISTENING = org.jeromq.ZMQ::EVENT_LISTENING
    
  EVENT_BIND_FAILED = org.jeromq.ZMQ::EVENT_BIND_FAILED
    
  EVENT_ACCEPTED = org.jeromq.ZMQ::EVENT_ACCEPTED
    
  EVENT_ACCEPT_FAILED = org.jeromq.ZMQ::EVENT_ACCEPT_FAILED
    
  EVENT_CLOSED = org.jeromq.ZMQ::EVENT_CLOSED

  EVENT_CLOSE_FAILED = org.jeromq.ZMQ::EVENT_CLOSE_FAILED

  EVENT_DISCONNECTED = org.jeromq.ZMQ::EVENT_DISCONNECTED

  EVENT_ALL = org.jeromq.ZMQ::EVENT_ALL
=end
  IDENTITY = ZMQ::ZMQ_IDENTITY

  LINGER = ZMQ::ZMQ_LINGER

  ########### DATA SERIALIZATION #########

  require 'edn'

  def read(data)
    EDN.read(data)
  end

  def write(data)
    data.to_edn
  end
  
end
