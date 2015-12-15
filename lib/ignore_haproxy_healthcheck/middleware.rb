module IgnoreHAProxyHealthcheck
  class Middleware
    attr_reader :app

    def initialize(app)
      @app = app
    end

    def call(env)
      if env['HTTP_USER_AGENT'] == "HAProxy-HealthCheck"
        if defined?(NewRelic::Agent)
          NewRelic::Agent.ignore_transaction
        end
        [200, {'Content-Type' => 'text/plain'}, ["OK"]]
      else
        app.call(env)
      end
    end
  end
end
