require "./spec_helper"

abstract class Operation
  include Callback

  register_event :run, result
end

abstract class SaveOperation(T) < Operation
  register_event :save
  register_event :commit

  def save(item : T)
    run_event :run do
      run_event :save do
        run_event :commit do
          puts "SAVING..."
        end
      end
    end
  end
end

class MySaveOp < SaveOperation(String)
  before_save :validation
  before_save :modifying
  after_commit :post_commit
  after_run :finishing
  after_save :saved
  around_run :woah

  def woah
    puts "BEFORE"
    result = yield
    puts "AFTER"
  end

  def validation
    puts "Validating..."
  end

  def modifying
    puts "Modifying..."
  end

  def post_commit
    puts "Post committing..."
  end

  def finishing(result)
    puts "Finishing..."
  end

  def saved
    puts "Saved..."
  end
end

describe Callback do
  # TODO: Write tests

  it "works" do
    MySaveOp.new.save("string")
  end
end
