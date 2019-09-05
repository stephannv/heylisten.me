every :hour, at: 1 do
  runner 'ExecuteHourlyUpdate.run!'
end
