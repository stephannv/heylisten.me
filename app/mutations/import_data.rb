class ImportData < Mutations::Command
  def execute
    # import_nintendo_brasil_data
    import_nintendo_europe_data
    import_nintendo_north_america_data
    import_nintendo_japan_data
  end

  private def import_nintendo_europe_data
    %w[game dlc].each do |data_type|
      Task.start "Import Nintendo Europe #{data_type} data" do
        ImportNintendoEuropeData.run!(data_type: data_type)
      end
    end

    Task.start 'Dispatch Nintendo Europe updates' do
      DispatchPendingDiscordEvents.run!
    end
  end

  private def import_nintendo_north_america_data
    Task.start 'Import Nintendo North America data' do
      ImportNintendoNorthAmericaData.run!
    end

    Task.start 'Dispatch Nintendo America updates' do
      DispatchPendingDiscordEvents.run!
    end
  end

  private def import_nintendo_brasil_data
    Task.start 'Import Nintendo Brasil data' do
      ImportNintendoBrasilData.run!
    end

    Task.start 'Dispatch Nintendo Brasil updates' do
      DispatchPendingDiscordEvents.run!
    end
  end

  private def import_nintendo_japan_data
    Task.start 'Import Nintendo Japan data' do
      ImportNintendoJapanData.run!
    end

    Task.start 'Dispatch Nintendo Japan updates' do
      DispatchPendingDiscordEvents.run!
    end
  end
end
