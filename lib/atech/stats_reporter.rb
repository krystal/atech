module Atech
  ## The aTech stats reporter return information about the application which
  ## can be access by accessing the stats URL. This should be configured in your
  ## application initializer.
  ##
  ## Atech::StatsReporter.application_name = 'my-application'
  ## Atech::StatsReporter.application_key = 'your random key here'
  ## Atech::StatsReporter.stats = Proc.new do
  ##   {
  ##     :last_activity => Event.last.created_at,
  ##     :projects => Project.count,
  ##     :repositories => Repositories::Repository.count,
  ##     :disk_usage => Repositories::Repository.sum(:disk_usage)
  ##   }
  ## end
  ##
  class StatsReporter
    
    class << self
      attr_accessor :application_name
      attr_accessor :application_key
      attr_accessor :stats
      
      def application_name
        @application_name ||= "Application"
      end
      
      def stats
        @stats ||= Proc.new do
          Hash.new
        end
      end
      
      def repo_stats
        @repo_stats ||= {
          :ref => `git log --pretty='%H' -n 1`.chomp,
          :path => `git remote show -n origin | grep Fetch`.split(/\:\s*/, 2).last.strip
        }
      end
    end
    
    def call(env)
      dup._call(env)
    end
    
    def _call(env)
      req = Rack::Request.new(env)
      
      if req.params['key'] != self.class.application_key
        return [403, {}, ["Access Denied"]]
      end
      
      hash = {
        :name => self.class.application_name,
        :repo => self.class.repo_stats,
        :props => self.class.stats.call
      }
      
      [200, {}, [ActiveSupport::JSON.encode(hash)]]
    end
    
  end
end
