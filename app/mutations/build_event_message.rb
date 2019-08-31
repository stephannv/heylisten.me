class BuildEventMessage < Mutations::Command
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
    data_source = event.data['data_source_cd'].humanize.titleize

    if event.item_added?
      "A new #{item_type} was added to #{data_source}."
    elsif event.item_changed?
      "There was an update on a #{item_type} on #{data_source}."
    end
  end

  private def new_line
    "\n"
  end

  private def item_title
    event.data['title']
  end

  private def item_release_date
    "Release date: #{event.data['pretty_release_date']}"
  end

  private def item_website
    "More info at: #{event.data['website_url']}"
  end
end
