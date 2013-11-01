
module ZMQ

  require_jars(%w(jeromq))

  java_import 'zmq.ZMQ'
  java_import 'zmq.Msg'

  class Socket < org.jeromq.ZMQ::Socket
    include EDN
    def setsockopt(opt, val)
      self.base.setsockopt opt, val
    end
    def send_edn(msg)
      edn_msg = (msg.is_a? String) ? msg : msg.to_edn
      self.send edn_msg
    end
    def recv_edn()
      msg = self.recv_str
      rb_data = EDN.read(msg)
      rb_data
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
    def initialize(context=nil, size=32)
      super(context, size)
    end
  end

  class PollItem < org.jeromq.ZMQ::PollItem
    def initialize(s, ops)
      super(s, ops)
    end
  end

  class Message < org.jeromq.ZMQ::Msg
    def initialize(src)
      super(src)
    end
  end

  class ZMQQueue < org.jeromq::ZMQQueue
  end
end