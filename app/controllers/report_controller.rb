class ReportController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_body, only: [:callback]


  def auth
    p body = JSON.parse(params[:payload])
  end

  def callback
    case @body['type']
    when 'url_verification'
      render json: @body
    when 'event_callback'
      Slack.configure do |config|
        config.token = ENV['SLACK_BOT_USER_TOKEN']
      end
      if @body['event']['type'] == 'message' && @body['event']['user'] != 'U6KRQQF2B' && /<!channel>/.match(@body['event']['text'])
        client.chat_postMessage(
          as_user: 'true',
          channel: @body['event']['channel'],
          text: @body['event']['text'],
          attachments: judge_menu
        )
      end
      head :ok
    end
  end

  def decision
    Slack.configure do |config|
      config.token = ENV['SLACK_USER_TOKEN']
    end
    body = JSON.parse(params[:payload])
    if body['actions'][0]['value'] == 'kick'
      client.channels_kick(channel: body['channel']['id'], user: body['callback_id'])
    end
  end

  private

  def client
    @client = Slack::Web::Client.new
  end

  def set_body
    @body = JSON.parse(request.body.read)
  end

  def judge_menu
    [{
      "fallback": "Is this mention reasonable?",
      "title": "Is this mention reasonable?",
      "callback_id": @body['event']['user'],
      "color": "#3AA3E3",
      "attachment_type": "default",
      "actions": [
        {
          "name": "kick",
          "text": "No. Kick!!",
          "type": "button",
          "value": "kick"
        },
        {
          "name": "yes",
          "text": "Yes",
          "type": "button",
          "value": "yes"
        }
      ]
    }]
  end
end
