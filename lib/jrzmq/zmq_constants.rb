
module ZMQ

  require_jars(%w(jeromq))

  java_import 'zmq.ZMQ'
  java_import 'zmq.Msg'

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

  SUBSCRIBE = ZMQ::ZMQ_SUBSCRIBE

  UNSUBSCRIBE = ZMQ::ZMQ_UNSUBSCRIBE
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
end