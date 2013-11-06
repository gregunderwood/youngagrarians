object :@category

attributes :id, :name

child :subcategories do
  extends 'subcategories/show'
end