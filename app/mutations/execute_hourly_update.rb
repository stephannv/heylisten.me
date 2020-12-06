class ExecuteHourlyUpdate < Mutations::Command
  def execute
    ImportData.run!
  end
end
