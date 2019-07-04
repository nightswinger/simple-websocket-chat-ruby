# frozen_string_literal: true

require 'aws-sdk-dynamodb'
require 'aws-sdk-apigatewaymanagementapi'

class WebsocketApi
  @dynamoDB = Aws::DynamoDB::Resource.new(region: 'ap-northeast-1')
  @table = @dynamoDB.table(ENV['TABLE_NAME'])

  def self.connect(event:, context:)
    params = {
      item: {
        connectionId: event['requestContext']['connectionId']
      }
    }
    begin
      @table.put_item(params)
      return {
        statusCode: 200,
        body: 'Connected'
      }
    rescue StandardError => e
      puts "Failed to connect: #{e}"
      return {
        statusCode: 500
      }
    end
  end
end
