require 'discordrb/webhooks'

class DispatchPendingDiscordEvents < Mutations::Command
  def execute
    dispatch_events
  end

  private def dispatch_events
    pending_events = nil

    (1..).each do |page|
      pending_events = fetch_pending_events(page: page)

      break if pending_events.blank?

      client.execute(build_builder(pending_events))
      pending_events.update(dispatches: { situation: :done })
    end
  rescue StandardError => e
    pending_events.update(dispatches: { situation: :failed, message: e.message })
  end

  private def fetch_pending_events(page:)
    Event
      .elem_match(dispatches: { target_cd: 'discord', situation_cd: 'pending' })
      .offset(10 * (page - 1))
      .limit(10)
  end

  private def client
    @client ||= Discordrb::Webhooks::Client.new(url: Rails.application.credentials.discord_webhook_url)
  end

  private def build_builder(events)
    builder = Discordrb::Webhooks::Builder.new
    builder.content = 'Hey, Listen me! Here go some updates for you'
    events.each do |event|
      builder << build_embed(event)
    end
    builder
  end

  private def build_embed(event)
    embed = Discordrb::Webhooks::Embed.new
    embed.color = 65_518
    embed.title = event.webhook_data['title']
    embed.url = event.webhook_data['url']
    embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.webhook_data['image_url'])
    event.webhook_data['fields'].each do |field|
      embed.add_field(name: field['name'], value: field['value'])
    end
    embed
  end
end
