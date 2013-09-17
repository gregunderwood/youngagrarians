class Youngagrarians.Views.Sidebar extends Backbone.Marionette.Layout
  template: "backbone/templates/sidebar"
  itemView: Youngagrarians.Views.SidebarItem

  regions:
    provinces:  "#map-provinces"
    bioregions: "#map-bioregions"
    legend:     "#map-legend-container"
    selectedCategories: '#map-selected-categories'
    selectedSubcategories: '#map-selected-subcategories'
    search:     "#map-search"
    extras:     "#extras"

  events:
    "click a.hide-show": "toggleLegend"

  initialize: (options) ->
    @app = options.app
    @data = options.data
    @provincesView = new Youngagrarians.Views.Provinces 
      results: options.results      
    @legendView = new Youngagrarians.Views.Legend 
      collection: @data.categories
      app: @app
    @searchView = new Youngagrarians.Views.Search 
      app: @app
    @extrasView = new Youngagrarians.Views.Extras 
      app: @app
    @selectedCategoriesView = new Youngagrarians.Views.SelectedCategories
      app: @app
      collection: options.results.selectedCategories
    @selectedSubcategoriesView = new Youngagrarians.Views.SelectedCategories
      app: @app
      collection: options.results.selectedSubcategories
    @app.vent.on 'province:change', @provinceChanged
  
  onRender: =>
    @provinces.show @provincesView
    @legend.show @legendView
    @search.show @searchView
    @extras.show @extrasView
    @selectedCategories.show @selectedCategoriesView
    @selectedSubcategories.show @selectedSubcategoriesView
  
  provinceChanged: (options)=>
    0
  
  toggleLegend: (e) =>
    e.preventDefault()

    currentlyShown = !!$(e.target).data('legend-shown')

    if currentlyShown
      $(e.target).data('legend-shown', 0).text("Show")
      $( @legendView.el ).hide()
    else
      $(e.target).data('legend-shown', 1).text("Hide")
      $( @legendView.el ).show()
