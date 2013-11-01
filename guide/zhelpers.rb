def s_dump(sock)
  puts "------------------------------------"
  # Build an array to hold all the parts
  messages = []
  zmsg = sock.recv

  zmsg.each do |frame|
    messages << frame
  end if zmsg

  # messages is an array of ZMQ::Message objects
  messages.each do |msg|
    if msg == messages[0]
      # identity - Naive implementation
      msg.size == 17 ? puts("Identity: #{msg.to_s.unpack('H*')[0]}") : puts("Identity: #{msg.to_s}")
    else
      # body
      puts "Data: #{msg.to_s}"
    end
  end
  puts "Msg: #{zmsg.to_s}"
end
