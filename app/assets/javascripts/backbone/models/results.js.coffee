class Youngagrarians.Collections.ResultsCollection extends Backbone.Collection
  model: Youngagrarians.Models.Location
  
  initialize: (options)=>
    @locations = options.locations
    @currentProvice = null
    @currentBioregion = null
    
  addCategory: (id)=>
    locations = @locations.filter (location)=>
      location.get('category').id == id
    @.reset locations
  
  removeCategory: (id)=>
    locations = @locations.filter (location)=>
      location.get('category').id == id
    @.reset locations
    
  changeRegion: (options)=>
    debugger
    
  search: (terms)=>
    debugger
    
  clearSearch: =>
    debugger
    
  addSubcategory: (id)=>
    debugger
    
  removeSubcategory: (id)=>
    debugger
    
  clear
    
