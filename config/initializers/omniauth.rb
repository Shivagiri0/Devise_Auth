Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '835034372756-bc5862aocdl2b0on9mh40s68044sbf0u.apps.googleusercontent.com', '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',
  {
    access_type: 'offline'
  }
  provider :github, '8ebae52a29e555f3386c', '0eb847a4965fdafe47dcee51ff245de35d42d4de'
end
