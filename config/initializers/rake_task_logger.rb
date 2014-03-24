module Rake
  class Task
    alias_method :origin_invoke, :invoke if method_defined?(:invoke)
    def invoke(*args)
      logger = Logger.new('rake_tasks_log.log')
      logger.info "#{Time.now} -- #{name} -- #{args.inspect}"
      origin_invoke(args)
    end
  end
end
