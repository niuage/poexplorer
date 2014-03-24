require 'thread'

class ThreadPool
  def initialize(size)
    @size = size
    @jobs = Queue.new
    @pool = Array.new(@size) do |i|
      Thread.new do
        Thread.current[:id] = i
        catch(:exit) do
          loop do
            puts %Q{
              //////////////////////////////////
              //////////////////////////////////
              //////////////////////////////////
              //////////////////////////////////
              //////////////////////////////////
              ///////////// JOB #{Thread.current[:id]} ///////////
              //////////////////////////////////
              //////////////////////////////////
              //////////////////////////////////
              //////////////////////////////////
              //////////////////////////////////
              //////////////////////////////////

            }
            job, args = @jobs.pop
            job.call(*args) if job
          end
        end
      end
    end
  end
  def schedule(*args, &block)
    @jobs << [block, args]
  end
  def shutdown
    @size.times do
      schedule { throw :exit }
    end
    @pool.map(&:join)
  end
end
