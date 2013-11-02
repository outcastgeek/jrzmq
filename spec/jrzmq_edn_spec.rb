require 'spec_helper'

describe EDN do
  include RantlyHelpers

  before(:each) do
    @context = ZMQ::Context.new(1)

    @inbound = @context.socket(ZMQ::UPSTREAM)
    @inbound.bind("ipc://edn_bus")

    @outbound = @context.socket(ZMQ::DOWNSTREAM)
    @outbound.connect("ipc://edn_bus")
  end

  after(:each) do
    @inbound.close
    @outbound.close
    @context.term
  end

  def send_and_receive_edn(msg)
    @outbound.send_edn msg
    @inbound.recv_edn
  end

  context "#read" do
    it "reads single elements" do
      send_and_receive_edn("1").should == 1
      send_and_receive_edn("3.14").should == 3.14
      send_and_receive_edn("3.14M").should == BigDecimal("3.14")
      send_and_receive_edn('"hello\nworld"').should == "hello\nworld"
      send_and_receive_edn(':hello').should == :hello
      send_and_receive_edn(':hello/world').should == :"hello/world"
      send_and_receive_edn('hello').should == EDN::Type::Symbol.new('hello')
      send_and_receive_edn('hello/world').should == EDN::Type::Symbol.new('hello/world')
      send_and_receive_edn('true').should == true
      send_and_receive_edn('false').should == false
      send_and_receive_edn('nil').should == nil
      send_and_receive_edn('\c').should == "c"
    end

    it "should support M suffix without decimals" do
      send_and_receive_edn(123412341231212121241234.to_edn).should == 123412341231212121241234
      send_and_receive_edn("123412341231212121241234M").should == 123412341231212121241234
    end

    it "reads #inst tagged elements" do
      send_and_receive_edn('#inst "2012-09-10T16:16:03-04:00"').should == DateTime.new(2012, 9, 10, 16, 16, 3, '-04:00')
    end

    it "reads vectors" do
      send_and_receive_edn('[]').should == []
      send_and_receive_edn('[1]').should == [1]
      send_and_receive_edn('["hello" 1 2]').should == ['hello', 1, 2]
      send_and_receive_edn('[[1 [:hi]]]').should == [[1, [:hi]]]
    end

    it "reads lists" do
      send_and_receive_edn('()').should == []
      send_and_receive_edn('(1)').should == [1]
      send_and_receive_edn('("hello" 1 2)').should == ['hello', 1, 2]
      send_and_receive_edn('((1 (:hi)))').should == [[1, [:hi]]]
    end

    it "reads maps" do
      send_and_receive_edn('{}').should == {}
      send_and_receive_edn('{:a :b}').should == {:a => :b}
      send_and_receive_edn('{:a 1, :b 2}').should == {:a => 1, :b => 2}
      send_and_receive_edn('{:a {:b :c}}').should == {:a => {:b => :c}}
    end

    it "reads sets" do
      send_and_receive_edn('#{}').should == Set.new
      send_and_receive_edn('#{1}').should == Set[1]
      send_and_receive_edn('#{1 "abc"}').should == Set[1, "abc"]
      send_and_receive_edn('#{1 #{:abc}}').should == Set[1, Set[:abc]]
    end

    it "reads any valid element" do
      elements = rant(RantlyHelpers::ELEMENT)
      elements.each do |element|
        begin
          if element == "nil"
            send_and_receive_edn(element).should be_nil
          else
            send_and_receive_edn(element).should_not be_nil
          end
        rescue Exception => ex
          puts "Bad element: #{element}"
          raise ex
        end
      end
    end
  end

  context "#register" do
    it "uses the identity function when no handler is given" do
      EDN.register "some/tag"
      send_and_receive_edn("#some/tag {}").class.should == Hash
    end
  end

  context "writing" do
    it "writes any valid element" do
      elements = rant(RantlyHelpers::ELEMENT)
      elements.each do |element|
        expect {
          begin
            send_and_receive_edn(element).to_edn
          rescue Exception => ex
            puts "Bad element: #{element}"
            raise ex
          end
        }.to_not raise_error
      end
    end

    it "writes equivalent edn to what it reads" do
      elements = rant(RantlyHelpers::ELEMENT)
      elements.each do |element|
        ruby_element = send_and_receive_edn(element)
        ruby_element.should == send_and_receive_edn(ruby_element.to_edn)
        if ruby_element.respond_to?(:metadata)
          ruby_element.metadata.should == send_and_receive_edn(ruby_element.to_edn).metadata
        end
      end
    end
  end
end
