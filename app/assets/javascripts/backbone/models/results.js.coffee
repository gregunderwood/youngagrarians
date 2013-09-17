class Youngagrarians.Collections.ResultsCollection extends Backbone.Collection
  model: Youngagrarians.Models.Location
  
  initialize: (options)=>
    @locations = options.locations
    @currentProvice = null
    @currentBioregion = null
    @currentTerms = null
    @selectedCategories = new Backbone.Collection()
    @selectedSubcategories = new Backbone.Collection()
    
  addCategory: (category)=>
    @selectedCategories.add category
    @update()
  
  removeCategory: (category)=>
    @selectedCategories.remove category 
    @update()
  
  addSubcategory: (subcategory)=>
    @selectedSubcategories.add subcategory
    @update()
  
  removeSubcategory: (subcategory)=>
    @selectedSubcategories.remove category 
    @update()
    
  changeRegion: (options)=>
    @currentProvince = options.province if  options.province
    @currentBioregion = options.bioregion if options.bioregion 
    @update()
  
  search: (terms)=>
    @currentTerms = terms
    @update()
    
  clearSearch: =>
    if terms
      terms = null
      @update()
    
  update: =>
    locations = []
    @selectedCategories.each (category)=>
      locations = _.union locations, @locations.filter (location)=>
        location.get('category').id == category.id
    @.reset _.uniq locations
