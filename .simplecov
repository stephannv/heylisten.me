
SimpleCov.start do
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Models', 'app/models'

  add_filter 'config'
  add_filter 'spec'
  add_filter 'app/jobs'
  add_filter 'app/channels'
  add_filter 'app/mailers'
end
