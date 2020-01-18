class ImportData < Mutations::Command
  def execute
    import_nintendo_europe_data
    import_nintendo_north_america_data
    import_nintendo_south_america_data
  end

  private def import_nintendo_europe_data
    %w[game dlc].each do |data_type|
      Task.start "Import Nintendo Europe #{data_type} data" do
        ImportNintendoEuropeData.run!(data_type: data_type)
      end
    end
  end

  private def import_nintendo_north_america_data
    Task.start 'Import Nintendo North America data' do
      ImportNintendoNorthAmericaData.run!
    end
  end

  private def import_nintendo_south_america_data
    Task.start 'Import Nintendo South America data' do
      ImportNintendoSouthAmericaData.run!
    end
  end
end
