
SimpleCov.start do
  add_group 'Controllers', 'app/controllers'
  add_group 'Data Adapters', 'app/data_adapters'
  add_group 'Helpers', 'app/helpers'
  add_group 'Models', 'app/models'
  add_group 'Mutations', 'app/mutations'
  add_group 'Services', 'app/services'

  add_filter 'config'
  add_filter 'spec'
  add_filter 'app/jobs'
  add_filter 'app/channels'
  add_filter 'app/mailers'
end
