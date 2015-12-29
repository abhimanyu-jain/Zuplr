json.array!(@userinfos) do |userinfo|
  json.extract! userinfo, :id, :user_id, :data
  json.url userinfo_url(userinfo, format: :json)
end
