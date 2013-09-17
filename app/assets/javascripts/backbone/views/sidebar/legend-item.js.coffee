class Youngagrarians.Views.LegendItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/legend-item"
  tagName: "li"

  events:
    "click a.select-category": "selectCat"
    "click a.show-subcategories": "showSubcategories"
    
  initialize: (options) =>
    @app = options.app

  serializeData: =>
    data = @model.toJSON()
    data.img = @model.getIcon()
    data

  showSubcategories: =>
    debugger;

  selectCat: (e) =>
    e.preventDefault()
    @app.vent.trigger "category:add", @model
