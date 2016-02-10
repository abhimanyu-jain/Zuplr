json.array!(@userprofiles) do |userprofile|
  json.extract! userprofile, :id, :data, :city, :phonenumber
  json.url userprofile_url(userprofile, format: :json)
end
