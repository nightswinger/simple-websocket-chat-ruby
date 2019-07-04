# frozen_string_literal: true

class WebsocketApi
  def self.default(event:, context:)
    puts 'default route was called'
    puts "event: #{JSON.dump(event)}"
    { statusCode: 200 }
  end
end
