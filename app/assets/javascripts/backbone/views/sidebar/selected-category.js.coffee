class Youngagrarians.Views.SelectedCategory extends Backbone.Marionette.ItemView
  
  template: "backbone/templates/sidebar/selected-category"
  tagName: 'li'  

  events:
    "click a.clear-category": "clearCategory"
    
  initialize: (options) =>
    @app = options.app

  clearCategory: =>
    @app.vent.trigger @model.removeEvent, @model
