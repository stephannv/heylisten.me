class ExecuteHourlyUpdate < Mutations::Command
  def execute
    ImportData.run!
    TweetPendingEvents.run!
  end
end
