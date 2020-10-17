require "./spec_helper"

abstract class Operation(T)
  include Callback

  register_event :before_run
  register_event :after_run, T

  abstract def do_run : T

  def run
    run_event :before_run
    result = do_run
    run_event :after_run, result
  end
end

class MyOp < Operation(Int32)
  before_run { puts "heyyyy" }
  after_run { |x| puts "The number is #{x}" }
  def do_run : Int32
    32
  end
end

describe Callback do
  # TODO: Write tests

  it "works" do
    MyOp.new.run
  end
end
