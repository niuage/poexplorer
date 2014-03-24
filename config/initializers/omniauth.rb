Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '3vNyoAXjGFueNdY7BN6UA', 'PulQwx4REpmusevEZMAiCu9TJnNyTLi5pVgImimNE'

  fb_scope = { scope: 'email' }

  if Rails.env.production?
    provider :facebook, '443387389070152', 'd377582e7725f62ea6a52172a8622f0a', fb_scope
  else
    provider :facebook, '138995959538207', 'f063460b1a5bb715cf1164a9e00dae36', fb_scope
  end
end
