class BuildEventWebhookData < Mutations::Command
  FLAGS = {
    nintendo_america: '🇺🇸🇨🇦🇲🇽',
    nintendo_europe: '🇪🇺',
    nintendo_brasil: '🇧🇷',
    nintendo_japan: '🇯🇵'
  }.freeze

  required do
    model :event, type: Event, new_records: true
  end

  # rubocop:disable Metrics/MethodLength
  def execute
    {
      title: event.data['title'],
      url: event.data['website_url'],
      image_url: event.data['image_url'],
      fields: [
        {
          name: 'Event',
          value: event_message
        },
        {
          name: 'Release Date',
          value: event.data['pretty_release_date'].presence || 'TBD'
        }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength

  private def event_message
    item_type = event.data['item_type_cd'].titleize
    data_source = data_source_title(event.data['data_source_cd'])
    event_type = event.item_added? ? 'added' : 'updated'

    "#{item_type} #{event_type} - #{data_source}"
  end

  private def data_source_title(data_source)
    flags = data_source_flags(data_source)
    "#{data_source.humanize.titleize} #{flags}"
  end

  private def data_source_flags(data_source)
    FLAGS[data_source.to_sym]
  end
end
