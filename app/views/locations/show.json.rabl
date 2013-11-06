object :@location

attributes :id, :latitude, :longitude, :gmaps, :address, :name, :content, :bioregion, :phone, :url, :fb_url, 
           :twitter_url, :description, :is_approved, :category_id, :resource_type, :email, :postal, :show_until,
           :street_address, :city, :country_code, :country_name, :province_code, :province_name
           
child(:category) do
  extends 'categories/show'
end

child(:subcategories) do
  extends 'subcategories/show'
end