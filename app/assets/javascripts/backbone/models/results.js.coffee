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
    category.get('subcategory').each (subcategory)=>
      subcategory = @selectedSubcategories.find (sub)->
        sub.id == subcategory.id
      @selectedSubcategories.remove subcategory if subcategory
    @update()
  
  removeCategory: (category)=>
    @selectedCategories.remove category 
    @update()
  
  addSubcategory: (subcategory)=>
    category = @selectedCategories.find (cat)->
      cat.id == subcategory.get('category_id')
    @selectedCategories.remove category if category
    @selectedSubcategories.add subcategory
    @update()
  
  removeSubcategory: (subcategory)=>
    @selectedSubcategories.remove subcategory 
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
    @selectedSubcategories.each (subcategory)=>
      locations = _.union locations, @locations.filter (location)=>
        _.find location.get('subcategory'), (s)->
          subcategory.id == s.id
    locations = _.where(locations, {province_code: @currentProvince}) if @currentProvince
    locations = _.where(locations, {bioregion: @currentBioregion}) if @currentBioregion
    @.reset _.uniq(locations)

