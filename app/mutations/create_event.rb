class CreateEvent < Mutations::Command
  required do
    model :item, class: Item
  end

  def execute
    item.events.create!(event_type: event_type, data: item.attributes) if event_type.present?
  rescue StandardError => e
    Rails.logger.error(e)
    true
  end

  private def event_type
    return if item.released_at.before?(Time.zone.today)

    @event_type ||= if item._id_changed?
      :item_added
    elsif item.title_changed? || item.pretty_release_date_changed?
      :item_changed
    end
  end
end
