Fabricator(:rating) do
  user
  article
  rating {rand(4) + 1}
end
