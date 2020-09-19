require "./spec_helper"

abstract class Operation
  include Callback

  register_callback :before_run
  register_callback :after_run, result
end

abstract class SaveOperation(T) < Operation
  register_callback :before_save
  register_callback :after_save, result : T
  register_callback :after_commit, result : T

  def save(item : T)
    call_before_run
    call_before_save
    puts "SAVING..."
    call_after_commit(item)
    call_after_save(item)
    call_after_run(item)
  end
end

class MySaveOp < SaveOperation(String)
  before_save :validation
  before_save :modifying
  after_commit :post_commit
  after_run :finishing
  after_save :saved

  def validation
    puts "Validating..."
  end

  def modifying
    puts "Modifying..."
  end

  def post_commit(result)
    puts "Post committing..."
  end

  def finishing(result)
    puts "Finishing..."
  end

  def saved(result)
    puts "Saved..."
  end
end

describe Callback do
  # TODO: Write tests

  it "works" do
    MySaveOp.new.save("string")
  end
end
