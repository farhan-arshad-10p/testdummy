Fabricator(:invite) do
  code { SecureRandom.urlsafe_base64(4) }
  active true
end
