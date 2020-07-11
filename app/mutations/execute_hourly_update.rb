class ExecuteHourlyUpdate < Mutations::Command
  def execute
    ImportData.run!
    DispatchPendingDiscordEvents.run!
    TweetPendingEvents.run!
  end
end
