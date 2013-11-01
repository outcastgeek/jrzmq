require 'spec_helper'

describe EDN do
  include RantlyHelpers

  before(:each) do
    @context = ZMQ::Context.new(1)

    @inbound = @context.socket(ZMQ::UPSTREAM)
    @inbound.bind("ipc://edn_bus")
    @inbound.set_receive_time_out 10

    @outbound = @context.socket(ZMQ::DOWNSTREAM)
    @outbound.connect("ipc://edn_bus")
    @outbound.set_send_time_out 10
  end

  after(:each) do
    @inbound.close
    @outbound.close
    @context.term
  end

  def check(msg)
    send_receive_edn(@inbound, @outbound, msg)
  end

  context "#read" do
    it "reads single elements" do
      check("1").should == 1
      check("3.14").should == 3.14
      check("3.14M").should == BigDecimal("3.14")
      check('"hello\nworld"').should == "hello\nworld"
      check(':hello').should == :hello
      check(':hello/world').should == :"hello/world"
      check('hello').should == EDN::Type::Symbol.new('hello')
      check('hello/world').should == EDN::Type::Symbol.new('hello/world')
      check('true').should == true
      check('false').should == false
      check('nil').should == nil
      check('\c').should == "c"
    end

    it "should support M suffix without decimals" do
      check(123412341231212121241234.to_edn).should == 123412341231212121241234
      check("123412341231212121241234M").should == 123412341231212121241234
    end

    it "reads #inst tagged elements" do
      check('#inst "2012-09-10T16:16:03-04:00"').should == DateTime.new(2012, 9, 10, 16, 16, 3, '-04:00')
    end

    it "reads vectors" do
      check('[]').should == []
      check('[1]').should == [1]
      check('["hello" 1 2]').should == ['hello', 1, 2]
      check('[[1 [:hi]]]').should == [[1, [:hi]]]
    end

    it "reads lists" do
      check('()').should == []
      check('(1)').should == [1]
      check('("hello" 1 2)').should == ['hello', 1, 2]
      check('((1 (:hi)))').should == [[1, [:hi]]]
    end

    it "reads maps" do
      check('{}').should == {}
      check('{:a :b}').should == {:a => :b}
      check('{:a 1, :b 2}').should == {:a => 1, :b => 2}
      check('{:a {:b :c}}').should == {:a => {:b => :c}}
    end

    it "reads sets" do
      check('#{}').should == Set.new
      check('#{1}').should == Set[1]
      check('#{1 "abc"}').should == Set[1, "abc"]
      check('#{1 #{:abc}}').should == Set[1, Set[:abc]]
    end

    it "reads any valid element" do
      elements = rant(RantlyHelpers::ELEMENT)
      elements.each do |element|
        begin
          if element == "nil"
            check(element).should be_nil
          else
            check(element).should_not be_nil
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
      check("#some/tag {}").class.should == Hash
    end
  end

  context "writing" do
    it "writes any valid element" do
      elements = rant(RantlyHelpers::ELEMENT)
      elements.each do |element|
        expect {
          begin
            check(element).to_edn
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
        ruby_element = check(element)
        ruby_element.should == check(ruby_element.to_edn)
        if ruby_element.respond_to?(:metadata)
          ruby_element.metadata.should == check(ruby_element.to_edn).metadata
        end
      end
    end
  end
end
