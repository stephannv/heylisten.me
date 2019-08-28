namespace :import do
  desc 'Import Items'
  task items: :environment do
    %i[game dlc].each do |data_type|
      Task.start "Import Nintendo Europe data - #{data_type}" do
        ImportNintendoEuropeData.run!(data_type: data_type)
      end
    end
  end
end
