class ImportData < Mutations::Command
  def execute
    import_nintendo_europe_data
  end

  private def import_nintendo_europe_data
    %w[game dlc].each do |data_type|
      Task.start "Import Nintendo Europe #{data_type} data" do
        ImportNintendoEuropeData.run!(data_type: data_type)
      end
    end
  end
end