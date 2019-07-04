# frozen_string_literal: true

require 'aws-sdk-dynamodb'
require 'aws-sdk-apigatewaymanagementapi'

class WebsocketApi
  @dynamoDB = Aws::DynamoDB::Resource.new(region: 'ap-northeast-1')
  @table = @dynamoDB.table(ENV['TABLE_NAME'])

  def self.disconnect(event:, context:)
    params = {
      key: {
        connectionId: event['requestContext']['connectionId']
      }
    }
    begin
      @table.delete_item(params)
      return {
        statusCode: 200,
        body: 'Disconnected'
      }
    rescue StandardError => e
      puts "Failed to disconnect: #{e}"
      return {
        statusCode: 500
      }
    end
 end
end
