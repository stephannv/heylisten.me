class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :status, type: String
  field :message, type: String

  index(created_at: -1)

  validates :name, presence: true
  validates :status, presence: true

  def self.start(name)
    task = create!(name: name, status: 'running')

    begin
      yield
      task.update!(status: 'finished')
    rescue StandardError => e
      Rails.logger.error(e)
      task.update!(status: 'failed', message: "#{e.class.name} - #{e.message}")
    end
  end
end
