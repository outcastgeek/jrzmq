require 'spec_help'
require 'jrzmq/context'

describe ZeroMQ::Context do
  it "instantiates a new ZeroMQ Context" do
    ZeroMQ::Context.new
  end
end

