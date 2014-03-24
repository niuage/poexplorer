CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAICHU6CYDY6D56FKQ',
    :aws_secret_access_key  => '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',
  }
  config.fog_directory  = 'niuage'
end
