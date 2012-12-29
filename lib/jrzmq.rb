require 'java'

module ZMQ

  %w{../jars/compile jrzmq}.each do |dir|
    path = File.expand_path(File.join(File.dirname(__FILE__), dir))
    $LOAD_PATH << path
  end

  def ZMQ.initialize_logger
    require_jars(%w(logback-access logback-classic logback-core logback-site slf4j-api))
    rootLogger = Java::OrgSlf4j::LoggerFactory.getLogger(Java::ChQosLogbackClassic::Logger.java_class)
    rootLoggerLogLevel = Java::ChQosLogbackClassic::Level::DEBUG
    rootLogger.setLevel(rootLoggerLogLevel)
    rootLogger.info "Root Logger Log Level was set to: #{rootLoggerLogLevel}"
  end

  def ZMQ.require_jars(*names)
    names.flatten.each do |name|
      require "#{name}.jar"
    end
  end
end

ZMQ.initialize_logger

require 'components'

