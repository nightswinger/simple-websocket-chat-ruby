# frozen_string_literal: true

require 'aws-sdk-dynamodb'
require 'aws-sdk-apigatewaymanagementapi'

class WebsocketApi
  @dynamoDB = Aws::DynamoDB::Resource.new(region: 'ap-northeast-1')
  @table = @dynamoDB.table(ENV['TABLE_NAME'])

  def self.send_message(event:, context:)
    begin
      resp = @table.scan(
        projection_expression: 'connectionId'
      )
    rescue Aws::DynamoDB::Errors::ServiceError => e
      return {
        statusCode: 500,
        body: e
      }
    end

    api_gw = Aws::ApiGatewayManagementApi::Client.new(
      endpoint: 'https://' + event['requestContext']['domainName'] + '/' + event['requestContext']['stage']
    )

    resp.items.map do |item|
      begin
        api_gw.post_to_connection(
          connection_id: item['connectionId'], data: JSON.parse(event['body'])['data']
        )
      rescue Aws::ApiGatewayManagementApi::Errors::Http410Error => e
        puts "Found stale connection, deleting #{item['connectionId']}"
        @table.delete_item(key: { connectionId: item['connectionId'] })
      rescue StandardError => e
        throw e
      end
    end
    { statusCode: 200, body: 'Data sent' }
  end
end
