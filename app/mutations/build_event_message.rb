class BuildEventMessage < Mutations::Command
  FLAGS = {
    nintendo_america: '🇺🇸🇨🇦🇲🇽',
    nintendo_europe: '🇪🇺',
    nintendo_brasil: '🇧🇷',
    nintendo_japan: '🇯🇵'
  }.freeze

  required do
    model :event, type: Event, new_records: true
  end

  def execute
    [
      introduction, ' ',
      message_title,
      new_line, new_line,
      item_title,
      new_line,
      item_release_date,
      new_line, new_line,
      item_website
    ].join
  end

  private def introduction
    'Hey, Listen!'
  end

  private def message_title
    item_type = event.data['item_type_cd']
    data_source = data_source_title(event.data['data_source_cd'])

    if event.item_added?
      "A new #{item_type} was added to #{data_source}."
    elsif event.item_changed?
      "There was an update on a #{item_type} on #{data_source}."
    end
  end

  private def data_source_title(data_source)
    flags = data_source_flags(data_source)
    "#{data_source.humanize.titleize} #{flags}"
  end

  private def new_line
    "\n"
  end

  private def item_title
    event.data['title']
  end

  private def item_release_date
    "Release date: #{event.data['pretty_release_date']}" if event.data['pretty_release_date'].present?
  end

  private def item_website
    "More info at: #{event.data['website_url']}"
  end

  private def data_source_flags(data_source)
    FLAGS[data_source.to_sym]
  end
end
