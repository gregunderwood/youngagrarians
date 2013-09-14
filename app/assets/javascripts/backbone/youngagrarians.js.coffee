#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

@Youngagrarians =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

@YA = new Backbone.Marionette.Application()

YA.addRegions
  map: "#map"
  sidebar: "#sidebar"
  results: "#results"

YA.addInitializer (options) ->
  data = 
    locations: new Youngagrarians.Collections.LocationsCollection()
    categories: new Youngagrarians.Collections.CategoriesCollection()
    subcategories: new Youngagrarians.Collections.SubcategoryCollection()
  
  for key, collection of data  
    collection.fetch
      reset: true

  results = new Youngagrarians.Collections.ResultsCollection
    locations: data.locations
    
  # I'm pretty sure it's something to do with backbone relational that is adding a model to my collection by default
  # but this hack clears the collection
  results.reset([])
  
  @sidebarView = new Youngagrarians.Views.Sidebar 
    data: data
    app: @    
  @.sidebar.show @sidebarView
  
  @mapView = new Youngagrarians.Views.Map
    collection: results
  @.map.show @mapView
  
  @resultsView = new Youngagrarians.Views.Results
    collection: results  
  @.results.show @resultsView

  @.vent.on 'province:change', results.changeRegion
  @.vent.on 'bioregion:change', results.changeRegion
  @.vent.on 'category:change', results.changeCategory
  @.vent.on 'search', results.search
  @.vent.on 'search:clear', results.clearSearch

YA.addInitializer (options) ->
  router = new Youngagrarians.Routers.LocationsRouter()
  Backbone.history.start()
