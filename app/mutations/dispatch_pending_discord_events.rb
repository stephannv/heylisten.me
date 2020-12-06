require 'discordrb/webhooks'

class DispatchPendingDiscordEvents < Mutations::Command
  def execute
    dispatch_events
  end

  private def dispatch_events
    loop do
      pending_events = fetch_pending_events

      break if pending_events.blank?

      begin
        client.execute(build_builder(pending_events), true)
      rescue => e
        pending_events.each { |e| e.dispatches.where(target_cd: 'discord').each { |d| d.update!(situation: :failed) } }
      else
        pending_events.each { |e| e.dispatches.where(target_cd: 'discord').each { |d| d.update!(situation: :done) } }
      end
    end
  end

  private def fetch_pending_events
    Event
      .elem_match(dispatches: { target_cd: 'discord', situation_cd: 'pending' })
      .limit(10)
      .to_a
  end

  private def client
    @client ||= Discordrb::Webhooks::Client.new(url: Rails.application.credentials.discord_webhook_url)
  end

  private def build_builder(events)
    builder = Discordrb::Webhooks::Builder.new
    builder.content = 'Here go some updates for you'
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
