
module ZMQ

  require_jars(%w(jeromq))

  java_import 'zmq.ZMQ'
  java_import 'zmq.Msg'

  class Socket < org.jeromq.ZMQ::Socket
    def setsockopt(opt, val)
      self.base.setsockopt opt, val.to_java(:int)
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
end