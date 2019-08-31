class TweetPendingEvents < Mutations::Command
  def execute
    fetch_pending_events
    tweet_events
  end

  private def fetch_pending_events
    @pending_events = Event.elem_match(dispatches: { situation_cd: 'pending' })
  end

  private def tweet_events
    return if @pending_events.empty?

    previous_tweet = nil

    @pending_events.each do |event|
      previous_tweet = TweetEvent.run!(event: event, previous_tweet: previous_tweet)
      event.dispatches.first.update(situation: :done)
    rescue StandardError => e
      event.dispatches.first.update(situation: :failed, message: e.message)
    end
  end
end
