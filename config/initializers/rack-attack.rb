class Rack::Attack
  throttle('req/ip', :limit => 60, :period => 1.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end
end
