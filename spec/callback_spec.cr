require "./spec_helper"

abstract class Operation
  include Callback

  register_event :before_run
  register_event :after_run, String

  abstract def do_run

  def run
    run_event :before_run
    do_run
    run_event :after_run, "moon"
  end
end

class MyOp < Operation
  before_run :print_hello
  after_run do |name|
    puts "WOAH #{name}"
  end
  after_run :print_goodbye

  def do_run
    "Hello, world!"
  end

  def print_hello
    puts "Hello!"
  end

  def print_goodbye(name)
    puts "Goodbye, #{name}"
  end
end

describe Callback do
  # TODO: Write tests

  it "works" do
    MyOp.new.run
  end
end
