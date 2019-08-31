class TweetEvent < Mutations::Command
  required do
    model :event, class: Event
  end

  optional do
    model :previous_tweet, class: Twitter::Tweet
  end

  def execute
    build_options
    download_image
    tweet
  end

  private def build_options
    @options = { in_reply_to_status_id: previous_tweet.try(:id) }
  end

  private def download_image
    @image = Down.download(event.data['image_url'], max_size: 5 * 1024 * 1024)
  end

  private def tweet
    client.update_with_media(event.message, @image, @options)
  end

  private def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.twitter_consumer_key
      config.consumer_secret = Rails.application.credentials.twitter_consumer_secret
      config.access_token = Rails.application.credentials.twitter_access_token
      config.access_token_secret = Rails.application.credentials.twitter_access_token_secret
    end
  end
end
